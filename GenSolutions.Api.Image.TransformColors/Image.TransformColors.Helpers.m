
#import "Image.TransformColors.h"

// raw data helpers
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
typedef unsigned int QRgb;

QRgb qAlpha( QRgb rgb ) { return ( (rgb >> 24) & 0xff ); }
QRgb qRed  ( QRgb rgb ) { return ( (rgb >> 16) & 0xff ); }
QRgb qGreen( QRgb rgb ) { return ( (rgb >>  8) & 0xff ); }
QRgb qBlue ( QRgb rgb ) { return ( (rgb >>  0) & 0xff ); }

QRgb hGray ( QRgb r, QRgb g, QRgb b ) { return ( (r*11 + g*16 + b*5) / 32 );  }
QRgb qGray ( QRgb rgb ) { return hGray( qRed(rgb), qGreen(rgb), qBlue(rgb) ); }

#define getLineAsArray( data, width, height, lineIndex ) ( data + lineIndex * width )

// constants
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
const float RLUM     = 0.3086;
const float GLUM     = 0.6094;
const float BLUM     = 0.0820;

const int   OFFSET_R = 3;
const int   OFFSET_G = 2;
const int   OFFSET_B = 1;
const int   OFFSET_A = 0;

// use a matrix to transform colors
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void applymatrix( unsigned long *lptr, float mat[4][4], int n ) {
    
    int ir, ig, ib, r, g, b;
    unsigned char *cptr;
    
    cptr = (unsigned char *)lptr;
    while(n--) {
        ir = cptr[OFFSET_R];
        ig = cptr[OFFSET_G];
        ib = cptr[OFFSET_B];
        r = ir*mat[0][0] + ig*mat[1][0] + ib*mat[2][0] + mat[3][0];
        g = ir*mat[0][1] + ig*mat[1][1] + ib*mat[2][1] + mat[3][1];
        b = ir*mat[0][2] + ig*mat[1][2] + ib*mat[2][2] + mat[3][2];
        if(r<0) r = 0;
        if(r>255) r = 255;
        if(g<0) g = 0;
        if(g>255) g = 255;
        if(b<0) b = 0;
        if(b>255) b = 255;
        cptr[OFFSET_R] = r;
        cptr[OFFSET_G] = g;
        cptr[OFFSET_B] = b;
        cptr += 4;
    }
}

// multiply two matricies
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void matrixmult( float a[4][4], float b[4][4], float c[4][4] ) {
    
    int x, y;
    float temp[4][4];
    
    for(y=0; y<4 ; y++)
    {
        for(x=0 ; x<4 ; x++)
        {
            temp[y][x] = 
            b[y][0] * a[0][x]
            + b[y][1] * a[1][x]
            + b[y][2] * a[2][x]
            + b[y][3] * a[3][x];
        }
    }
    
    for(y=0; y<4; y++)
    {
        for(x=0; x<4; x++)
        {
            c[y][x] = temp[y][x];
        }
    }
}

// make an identity matrix
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void identmat( float matrix[4][4] ) {
    
    matrix[0][0] = 1.0;    // row
    matrix[0][1] = 0.0;
    matrix[0][2] = 0.0;
    matrix[0][3] = 0.0;
    
    matrix[1][0] = 0.0;    // row 2
    matrix[1][1] = 1.0;
    matrix[1][2] = 0.0;
    matrix[1][3] = 0.0;
    
    matrix[2][0] = 0.0;    // row 3
    matrix[2][1] = 0.0;
    matrix[2][2] = 1.0;
    matrix[2][3] = 0.0;
    
    matrix[3][0] = 0.0;    // row 4
    matrix[3][1] = 0.0;
    matrix[3][2] = 0.0;
    matrix[3][3] = 1.0;
}

// transform a 3D point using a matrix
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void xformpnt( float matrix[4][4], float x, float y, float z, float* tx, float* ty, float* tz ) {
    
    *tx = x*matrix[0][0] + y*matrix[1][0] + z*matrix[2][0] + matrix[3][0];
    *ty = x*matrix[0][1] + y*matrix[1][1] + z*matrix[2][1] + matrix[3][1];
    *tz = x*matrix[0][2] + y*matrix[1][2] + z*matrix[2][2] + matrix[3][2];
}

// make a color scale marix
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void cscalemat( float mat[4][4], float rscale, float gscale, float bscale ) {
    
    float mmat[4][4];
    
    mmat[0][0] = rscale;
    mmat[0][1] = 0.0;
    mmat[0][2] = 0.0;
    mmat[0][3] = 0.0;
    
    mmat[1][0] = 0.0;
    mmat[1][1] = gscale;
    mmat[1][2] = 0.0;
    mmat[1][3] = 0.0;
    
    
    mmat[2][0] = 0.0;
    mmat[2][1] = 0.0;
    mmat[2][2] = bscale;
    mmat[2][3] = 0.0;
    
    mmat[3][0] = 0.0;
    mmat[3][1] = 0.0;
    mmat[3][2] = 0.0;
    mmat[3][3] = 1.0;
    
    matrixmult(mmat,mat,mat);
}

// make a luminance marix
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void lummat( float mat[4][4] ) {
    
    float mmat[4][4];
    float rwgt, gwgt, bwgt;
    
    rwgt = RLUM;
    gwgt = GLUM;
    bwgt = BLUM;
    
    mmat[0][0] = rwgt;
    mmat[0][1] = rwgt;
    mmat[0][2] = rwgt;
    mmat[0][3] = 0.0;
    
    mmat[1][0] = gwgt;
    mmat[1][1] = gwgt;
    mmat[1][2] = gwgt;
    mmat[1][3] = 0.0;
    
    mmat[2][0] = bwgt;
    mmat[2][1] = bwgt;
    mmat[2][2] = bwgt;
    mmat[2][3] = 0.0;
    
    mmat[3][0] = 0.0;
    mmat[3][1] = 0.0;
    mmat[3][2] = 0.0;
    mmat[3][3] = 1.0;
    
    matrixmult(mmat,mat,mat);
}

// make a saturation marix
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void saturatemat( float mat[4][4], float sat ) {
    
    float mmat[4][4];
    float a, b, c, d, e, f, g, h, i;
    float rwgt, gwgt, bwgt;
    
    rwgt = RLUM;
    gwgt = GLUM;
    bwgt = BLUM;
    
    a = (1.0-sat)*rwgt + sat;
    b = (1.0-sat)*rwgt;
    c = (1.0-sat)*rwgt;
    d = (1.0-sat)*gwgt;
    e = (1.0-sat)*gwgt + sat;
    f = (1.0-sat)*gwgt;
    g = (1.0-sat)*bwgt;
    h = (1.0-sat)*bwgt;
    i = (1.0-sat)*bwgt + sat;
    
    mmat[0][0] = a;
    mmat[0][1] = b;
    mmat[0][2] = c;
    mmat[0][3] = 0.0;
    
    mmat[1][0] = d;
    mmat[1][1] = e;
    mmat[1][2] = f;
    mmat[1][3] = 0.0;
    
    mmat[2][0] = g;
    mmat[2][1] = h;
    mmat[2][2] = i;
    mmat[2][3] = 0.0;
    
    mmat[3][0] = 0.0;
    mmat[3][1] = 0.0;
    mmat[3][2] = 0.0;
    mmat[3][3] = 1.0;
    
    matrixmult(mmat,mat,mat);
}

// offset r, g, and b
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void offsetmat( float mat[4][4], float roffset, float goffset, float boffset ) {
    
    float mmat[4][4];
    
    mmat[0][0] = 1.0;
    mmat[0][1] = 0.0;
    mmat[0][2] = 0.0;
    mmat[0][3] = 0.0;
    
    mmat[1][0] = 0.0;
    mmat[1][1] = 1.0;
    mmat[1][2] = 0.0;
    mmat[1][3] = 0.0;
    
    mmat[2][0] = 0.0;
    mmat[2][1] = 0.0;
    mmat[2][2] = 1.0;
    mmat[2][3] = 0.0;
    
    mmat[3][0] = roffset;
    mmat[3][1] = goffset;
    mmat[3][2] = boffset;
    mmat[3][3] = 1.0;
    
    matrixmult(mmat,mat,mat);
}

// otate about the x (red) axis
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void xrotatemat( float mat[4][4], float rs, float rc ) {
    
    float mmat[4][4];
    
    mmat[0][0] = 1.0;
    mmat[0][1] = 0.0;
    mmat[0][2] = 0.0;
    mmat[0][3] = 0.0;
    
    mmat[1][0] = 0.0;
    mmat[1][1] = rc;
    mmat[1][2] = rs;
    mmat[1][3] = 0.0;
    
    mmat[2][0] = 0.0;
    mmat[2][1] = -rs;
    mmat[2][2] = rc;
    mmat[2][3] = 0.0;
    
    mmat[3][0] = 0.0;
    mmat[3][1] = 0.0;
    mmat[3][2] = 0.0;
    mmat[3][3] = 1.0;
    
    matrixmult(mmat,mat,mat);
}

// rotate about the y (green) axis
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void yrotatemat( float mat[4][4], float rs, float rc ) {
    
    float mmat[4][4];
    
    mmat[0][0] = rc;
    mmat[0][1] = 0.0;
    mmat[0][2] = -rs;
    mmat[0][3] = 0.0;
    
    mmat[1][0] = 0.0;
    mmat[1][1] = 1.0;
    mmat[1][2] = 0.0;
    mmat[1][3] = 0.0;
    
    mmat[2][0] = rs;
    mmat[2][1] = 0.0;
    mmat[2][2] = rc;
    mmat[2][3] = 0.0;
    
    mmat[3][0] = 0.0;
    mmat[3][1] = 0.0;
    mmat[3][2] = 0.0;
    mmat[3][3] = 1.0;
    
    matrixmult(mmat,mat,mat);
}

// rotate about the z (blue) axis
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void zrotatemat( float mat[4][4], float rs, float rc ) {
    
    float mmat[4][4];
    
    mmat[0][0] = rc;
    mmat[0][1] = rs;
    mmat[0][2] = 0.0;
    mmat[0][3] = 0.0;
    
    mmat[1][0] = -rs;
    mmat[1][1] = rc;
    mmat[1][2] = 0.0;
    mmat[1][3] = 0.0;
    
    mmat[2][0] = 0.0;
    mmat[2][1] = 0.0;
    mmat[2][2] = 1.0;
    mmat[2][3] = 0.0;
    
    mmat[3][0] = 0.0;
    mmat[3][1] = 0.0;
    mmat[3][2] = 0.0;
    mmat[3][3] = 1.0;
    
    matrixmult(mmat,mat,mat);
}

// shear z using x and y.
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void zshearmat( float mat[4][4], float dx, float dy ) {
    
    float mmat[4][4];
    
    mmat[0][0] = 1.0;
    mmat[0][1] = 0.0;
    mmat[0][2] = dx;
    mmat[0][3] = 0.0;
    
    mmat[1][0] = 0.0;
    mmat[1][1] = 1.0;
    mmat[1][2] = dy;
    mmat[1][3] = 0.0;
    
    mmat[2][0] = 0.0;
    mmat[2][1] = 0.0;
    mmat[2][2] = 1.0;
    mmat[2][3] = 0.0;
    
    mmat[3][0] = 0.0;
    mmat[3][1] = 0.0;
    mmat[3][2] = 0.0;
    mmat[3][3] = 1.0;
    
    matrixmult(mmat,mat,mat);
}

// simple hue rotation. This changes luminance 
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void simplehuerotatemat( float mat[4][4], float rot ) {
    
    float mag;
    float xrs, xrc;
    float yrs, yrc;
    float zrs, zrc;
    
    // rotate the grey vector into positive Z
    mag = sqrt(2.0);
    xrs = 1.0/mag;
    xrc = 1.0/mag;
    xrotatemat(mat,xrs,xrc);
    
    mag = sqrt(3.0);
    yrs = -1.0/mag;
    yrc = sqrt(2.0)/mag;
    yrotatemat(mat,yrs,yrc);
    
    // rotate the hue
    zrs = sin(rot*M_PI/180.0);
    zrc = cos(rot*M_PI/180.0);
    zrotatemat(mat,zrs,zrc);
    
    // rotate the grey vector back into place
    yrotatemat(mat,-yrs,yrc);
    xrotatemat(mat,-xrs,xrc);
}

// rotate the hue, while maintaining luminance.
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
void huerotatemat( float mat[4][4], float rot ) {
    
    float mmat[4][4];
    float mag;
    float lx, ly, lz;
    float xrs, xrc;
    float yrs, yrc;
    float zrs, zrc;
    float zsx, zsy;
    
    identmat( mmat );
    
    // rotate the grey vector into positive Z
    mag = sqrt(2.0);
    xrs = 1.0/mag;
    xrc = 1.0/mag;
    xrotatemat(mmat,xrs,xrc);
    mag = sqrt(3.0);
    yrs = -1.0/mag;
    yrc = sqrt(2.0)/mag;
    yrotatemat(mmat,yrs,yrc);
    
    // shear the space to make the luminance plane horizontal
    xformpnt(mmat,RLUM,GLUM,BLUM,&lx,&ly,&lz);
    zsx = lx/lz;
    zsy = ly/lz;
    zshearmat(mmat,zsx,zsy);
    
    // rotate the hue
    zrs = sin(rot*M_PI/180.0);
    zrc = cos(rot*M_PI/180.0);
    zrotatemat(mmat,zrs,zrc);
    
    // unshear the space to put the luminance plane back
    zshearmat(mmat,-zsx,-zsy);
    
    // rotate the grey vector back into place
    yrotatemat(mmat,-yrs,yrc);
    xrotatemat(mmat,-xrs,xrc);
    
    matrixmult(mmat,mat,mat);
}
