
#import "Image.Skew.h"


@implementation UIImage( Skew )

+ (CATransform3D) computeTransformMatrix:(float)X 
                                       Y:(float)Y 
                                       W:(float)W 
                                       H:(float)H 
                                     x1a:(float)x1a
                                     y1a:(float)y1a 
                                     x2a:(float)x2a 
                                     y2a:(float)y2a 
                                     x3a:(float)x3a 
                                     y3a:(float)y3a 
                                     x4a:(float)x4a 
                                     y4a:(float)y4a
{
    float   y21 = y2a - y1a,  
            y32 = y3a - y2a,
            y43 = y4a - y3a,
            y14 = y1a - y4a,
            y31 = y3a - y1a,
            y42 = y4a - y2a;
    
    float a =        -H*( x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42 );
    float b =         W*( x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43 );

    float c =       H*X*( x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42 )
              - H*W*x1a*( x4a*y32     - x3a*y42     + x2a*y43                   )
                  - W*Y*( x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43 );
    
    float d = H*( -x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    float e = W*( x4a*y2a*y31  - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42              );

    float f = -(
                  W*  ( x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43       + x2a*Y*(y1a - y3a)*y4a + x1a*Y*y3a*(-y2a + y4a) )
                - H*X*( x4a*y21*y3a                 - x2a*y1a*y43         + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)                           )
               );
    
    float g = H*(  x3a*y21 - x4a*y21 + (-x1a + x2a)*y43 );
    float h = W*( -x2a*y31 + x4a*y31 + ( x1a - x3a)*y42 );

    float i = W*Y*( x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42 )
              + H*(  X*(-(x3a*y21) + x4a*y21 + x1a*y43 - x2a*y43) 
                   + W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a)
                  );

    {
//    return [
//                NSArray arrayWithObjects:
//                    [NSArray arrayWithObjects:[NSNumber numberWithFloat:a],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:c],nil],
//                    [NSArray arrayWithObjects:[NSNumber numberWithFloat:d],[NSNumber numberWithFloat:e],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:f],nil],
//                    [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1],[NSNumber numberWithFloat:0],nil],
//                    [NSArray arrayWithObjects:[NSNumber numberWithFloat:g],[NSNumber numberWithFloat:h],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:i],nil],
//                nil
//           ];
    }
    
    CATransform3D
        skewTransform;
        skewTransform.m11 = a;
        skewTransform.m12 = b;
        skewTransform.m13 = 0;
        skewTransform.m14 = c;
        skewTransform.m21 = d;
        skewTransform.m22 = e;
        skewTransform.m23 = 0;
        skewTransform.m24 = f;
        skewTransform.m31 = 0;
        skewTransform.m32 = 0;
        skewTransform.m33 = 1;
        skewTransform.m34 = 0;
        skewTransform.m41 = g;
        skewTransform.m42 = h;
        skewTransform.m43 = 0;
        skewTransform.m44 = i;
    
    return skewTransform;    
}





/*









using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
// (c) GMSE GmbH 2006
// Algorithm to deskew an image.

using System.Drawing;
using System.Drawing.Imaging;

public class main
{
	public static void Main()
	{
		string fnIn = "d:\\skewsample_in.tif";
		string fnOut = "d:\\skewsample_out.tif";
		Bitmap bmpIn = new Bitmap(fnIn);
		gmseDeskew sk = new gmseDeskew(bmpIn);
		double skewangle = sk.GetSkewAngle();
		Bitmap bmpOut = RotateImage(bmpIn, -skewangle);
		bmpOut.Save(fnOut, ImageFormat.Tiff);
		Interaction.MsgBox("Skewangle: " + skewangle);
	}
    
	private static Bitmap RotateImage(Bitmap bmp, double angle)
	{
		Graphics g = null;
		Bitmap tmp = new Bitmap(bmp.Width, bmp.Height, PixelFormat.Format32bppRgb);
        
		tmp.SetResolution(bmp.HorizontalResolution, bmp.VerticalResolution);
		g = Graphics.FromImage(tmp);
		try {
			g.FillRectangle(Brushes.White, 0, 0, bmp.Width, bmp.Height);
			g.RotateTransform(angle);
			g.DrawImage(bmp, 0, 0);
		} finally {
			g.Dispose();
		}
		return tmp;
	}
}

public class gmseDeskew
{
	// Representation of a line in the image.
	public class HougLine
	{
		// Count of points in the line.
		public int Count;
		// Index in Matrix.
		public int Index;
		// The line is represented as all x,y that solve y*cos(alpha)-x*sin(alpha)=d
		public double Alpha;
		public double d;
	}
	// The Bitmap
	Bitmap cBmp;
	// The range of angles to search for lines
	double cAlphaStart = -20;
	double cAlphaStep = 0.2;
	int cSteps = 40 * 5;
	// Precalculation of sin and cos.
	double[] cSinA;
	double[] cCosA;
	// Range of d
	double cDMin;
	double cDStep = 1;
	int cDCount;
	// Count of points that fit in a line.
    
	int[] cHMatrix;
	// Calculate the skew angle of the image cBmp.
	public double GetSkewAngle()
	{
		gmseDeskew.HougLine[] hl = null;
		int i = 0;
		double sum = 0;
		int count = 0;
        
		// Hough Transformation
		Calc();
		// Top 20 of the detected lines in the image.
		hl = GetTop(20);
		// Average angle of the lines
		for (i = 0; i <= 19; i++) {
			sum += hl[i].Alpha;
			count += 1;
		}
		return sum / count;
	}
    
	// Calculate the Count lines in the image with most points.
	private HougLine[] GetTop(int Count)
	{
		HougLine[] hl = null;
		int i = 0;
		int j = 0;
		HougLine tmp = null;
		int AlphaIndex = 0;
		int dIndex = 0;
        
		hl = new HougLine[Count + 1];
		for (i = 0; i <= Count - 1; i++) {
			hl[i] = new HougLine();
		}
		for (i = 0; i <= cHMatrix.Length - 1; i++) {
			if (cHMatrix[i] > hl[Count - 1].Count) {
				hl[Count - 1].Count = cHMatrix[i];
				hl[Count - 1].Index = i;
				j = Count - 1;
				while (j > 0 && hl[j].Count > hl[j - 1].Count) {
					tmp = hl[j];
					hl[j] = hl[j - 1];
					hl[j - 1] = tmp;
					j -= 1;
				}
			}
		}
		for (i = 0; i <= Count - 1; i++) {
			dIndex = hl[i].Index / cSteps;
			AlphaIndex = hl[i].Index - dIndex * cSteps;
			hl[i].Alpha = GetAlpha(AlphaIndex);
			hl[i].d = dIndex + cDMin;
		}
		return hl;
	}
	public gmseDeskew(Bitmap bmp)
	{
		cBmp = bmp;
	}
	// Hough Transforamtion:
	private void Calc()
	{
		int x = 0;
		int y = 0;
		int hMin = cBmp.Height / 4;
		int hMax = cBmp.Height * 3 / 4;
        
		Init();
		for (y = hMin; y <= hMax; y++) {
			for (x = 1; x <= cBmp.Width - 2; x++) {
				// Only lower edges are considered.
				if (IsBlack(x, y)) {
					if (!IsBlack(x, y + 1)) {
						Calc(x, y);
					}
				}
			}
		}
	}
	// Calculate all lines through the point (x,y).
	private void Calc(int x, int y)
	{
		int alpha = 0;
		double d = 0;
		int dIndex = 0;
		int Index = 0;
        
		for (alpha = 0; alpha <= cSteps - 1; alpha++) {
			d = y * cCosA[alpha] - x * cSinA[alpha];
			dIndex = CalcDIndex(d);
			Index = dIndex * cSteps + alpha;
			try {
				cHMatrix[Index] += 1;
			} catch (Exception ex) {
				Debug.WriteLine(ex.ToString());
			}
		}
	}
	private double CalcDIndex(double d)
	{
		return Convert.ToInt32(d - cDMin);
	}
	private bool IsBlack(int x, int y)
	{
		Color c = default(Color);
		double luminance = 0;
        
		c = cBmp.GetPixel(x, y);
		luminance = (c.R * 0.299) + (c.G * 0.587) + (c.B * 0.114);
		return luminance < 140;
	}
	private void Init()
	{
		int i = 0;
		double angle = 0;
        
		// Precalculation of sin and cos.
		cSinA = new double[cSteps];
		cCosA = new double[cSteps];
		for (i = 0; i <= cSteps - 1; i++) {
			angle = GetAlpha(i) * Math.PI / 180.0;
			cSinA[i] = Math.Sin(angle);
			cCosA[i] = Math.Cos(angle);
		}
		// Range of d:
		cDMin = -cBmp.Width;
		cDCount = 2 * (cBmp.Width + cBmp.Height) / cDStep;
		cHMatrix = new int[cDCount * cSteps + 1];
	}
    
	public double GetAlpha(int Index)
	{
		return cAlphaStart + Index * cAlphaStep;
	}
}

*/






@end
