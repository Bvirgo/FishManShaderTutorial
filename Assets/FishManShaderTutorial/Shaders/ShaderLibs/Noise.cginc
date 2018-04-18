// Merge by JiepengTan@gmail.com
#ifndef FMST_NOISE
#define FMST_NOISE

#define PI 3.14159265359
#define PI2 6.28318530718
#define Deg2Radius PI/180.

//https://www.shadertoy.com/view/4ssXRX   一些指定分布的Hash
//https://www.shadertoy.com/view/4djSRW  不使用三角函数实现的Hash
#define ITERATIONS 4
// *** Change these to suit your range of random numbers..
// *** Use this for integer stepped ranges, ie Value-Noise/Perlin noise functions.
#define HASHSCALE1 .1031
#define HASHSCALE3 float3(.1031, .1030, .0973)
#define HASHSCALE4 float4(.1031, .1030, .0973, .1099)
//----------------------------------------------------------------------------------------


sampler2D _NoiseTex;
//  1 out, 1 in...
float hash11(float p)
{
	float3 p3  = frac(p.xxx * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return frac((p3.x + p3.y) * p3.z); 
}

//----------------------------------------------------------------------------------------
//  1 out, 2 in...
float hash12(float2 p)
{
	float3 p3  = frac(float3(p.xyx) * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return frac((p3.x + p3.y) * p3.z);
}

//----------------------------------------------------------------------------------------
//  1 out, 3 in...
float hash13(float3 p3)
{
	p3  = frac(p3 * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return frac((p3.x + p3.y) * p3.z);
}

//----------------------------------------------------------------------------------------
//  2 out, 1 in...
float2 hash21(float p)
{
	float3 p3 = frac(p * HASHSCALE3);
	p3 += dot(p3, p3.yzx + 19.19);
    return frac((p3.xx+p3.yz)*p3.zy);

}

//----------------------------------------------------------------------------------------
///  2 out, 2 in...
float2 hash22(float2 p)
{
	float3 p3 = frac(float3(p.xyx) * HASHSCALE3);
    p3 += dot(p3, p3.yzx+19.19);
    return frac((p3.xx+p3.yz)*p3.zy);

}

//----------------------------------------------------------------------------------------
///  2 out, 3 in...
float2 hash23(float3 p3)
{
	p3 = frac(p3 * HASHSCALE3);
    p3 += dot(p3, p3.yzx+19.19);
    return frac((p3.xx+p3.yz)*p3.zy);
}

//----------------------------------------------------------------------------------------
//  3 out, 1 in...
float3 hash31(float p)
{
   float3 p3 = frac(p * HASHSCALE3); 
   p3 += dot(p3, p3.yzx+19.19);
   return frac((p3.xxy+p3.yzz)*p3.zyx); 
}


//----------------------------------------------------------------------------------------
///  3 out, 2 in...
float3 hash32(float2 p)
{
	float3 p3 = frac(float3(p.xyx) * HASHSCALE3);
    p3 += dot(p3, p3.yxz+19.19);
    return frac((p3.xxy+p3.yzz)*p3.zyx); 
}

//----------------------------------------------------------------------------------------
///  3 out, 3 in...
float3 hash33(float3 p3)
{
	p3 = frac(p3 * HASHSCALE3);
    p3 += dot(p3, p3.yxz+19.19);
    return frac((p3.xxy + p3.yxx)*p3.zyx);

}

//----------------------------------------------------------------------------------------
// 4 out, 1 in...
float4 hash41(float p)
{
	float4 p4 = frac(p * HASHSCALE4);
    p4 += dot(p4, p4.wzxy+19.19);
    return frac((p4.xxyz+p4.yzzw)*p4.zywx);
    
}

//----------------------------------------------------------------------------------------
// 4 out, 2 in...
float4 hash42(float2 p)
{
	float4 p4 = frac(float4(p.xyxy) * HASHSCALE4);
    p4 += dot(p4, p4.wzxy+19.19);
    return frac((p4.xxyz+p4.yzzw)*p4.zywx);

}

//----------------------------------------------------------------------------------------
// 4 out, 3 in...
float4 hash43(float3 p)
{
	float4 p4 = frac(float4(p.xyzx)  * HASHSCALE4);
    p4 += dot(p4, p4.wzxy+19.19);
    return frac((p4.xxyz+p4.yzzw)*p4.zywx);
}

//----------------------------------------------------------------------------------------
// 4 out, 4 in...
float4 hash44(float4 p4)
{
	p4 = frac(p4  * HASHSCALE4);
    p4 += dot(p4, p4.wzxy+19.19);
    return frac((p4.xxyz+p4.yzzw)*p4.zywx);
}
#if defined(USING_PERLIN_NOISE) 
	#define noise pnoise
#elif defined(USING_VALUE_NOISE) 
	#define noise vnoise
	#undefine USING_TEXLOD_NOISE
#elif defined(USING_SIMPLEX_NOISE) 
	#define noise snoise
#elif defined(USING_VNOISE) 
	#define noise vnoise
#else 
	#define USING_TEXLOD_NOISE
	#define noise vnoise
#endif 

// https://www.shadertoy.com/view/XdXBRH
float pnoise( in float2 p )
{
    float2 i = floor( p );
    float2 f = frac( p );
	
	float2 u = f*f*(3.0-2.0*f);

    return lerp( lerp( dot( hash22( i + float2(0.0,0.0) ), f - float2(0.0,0.0) ), 
                     dot( hash22( i + float2(1.0,0.0) ), f - float2(1.0,0.0) ), u.x),
                lerp( dot( hash22( i + float2(0.0,1.0) ), f - float2(0.0,1.0) ), 
                     dot( hash22( i + float2(1.0,1.0) ), f - float2(1.0,1.0) ), u.x), u.y);
}

float pnoise( in float3 p )
{
    float3 i = floor( p );
    float3 f = frac( p );
	
	float3 u = f*f*(3.0-2.0*f);

    return lerp( lerp( lerp( dot( hash33( i + float3(0.0,0.0,0.0) ), f - float3(0.0,0.0,0.0) ), 
                          dot( hash33( i + float3(1.0,0.0,0.0) ), f - float3(1.0,0.0,0.0) ), u.x),
                     lerp( dot( hash33( i + float3(0.0,1.0,0.0) ), f - float3(0.0,1.0,0.0) ), 
                          dot( hash33( i + float3(1.0,1.0,0.0) ), f - float3(1.0,1.0,0.0) ), u.x), u.y),
                lerp( lerp( dot( hash33( i + float3(0.0,0.0,1.0) ), f - float3(0.0,0.0,1.0) ), 
                          dot( hash33( i + float3(1.0,0.0,1.0) ), f - float3(1.0,0.0,1.0) ), u.x),
                     lerp( dot( hash33( i + float3(0.0,1.0,1.0) ), f - float3(0.0,1.0,1.0) ), 
                          dot( hash33( i + float3(1.0,1.0,1.0) ), f - float3(1.0,1.0,1.0) ), u.x), u.y), u.z );
}



// 带导数的noise的推导请参考Milo的 https://stackoverflow.com/questions/4297024/3d-perlin-noise-analytical-derivative
float3 noised( in float2 p )
{
    float2 i = floor( p );
    float2 f = frac( p );

#if 1
    // quintic interpolation
    float2 u = f*f*f*(f*(f*6.0-15.0)+10.0);
    float2 du = 30.0*f*f*(f*(f-2.0)+1.0);
#else
    // cubic interpolation
    float2 u = f*f*(3.0-2.0*f);
    float2 du = 6.0*f*(1.0-f);
#endif    
    
    float2 ga = hash22( i + float2(0.0,0.0) );
    float2 gb = hash22( i + float2(1.0,0.0) );
    float2 gc = hash22( i + float2(0.0,1.0) );
    float2 gd = hash22( i + float2(1.0,1.0) );
    
    float va = dot( ga, f - float2(0.0,0.0) );
    float vb = dot( gb, f - float2(1.0,0.0) );
    float vc = dot( gc, f - float2(0.0,1.0) );
    float vd = dot( gd, f - float2(1.0,1.0) );

    return float3( va + u.x*(vb-va) + u.y*(vc-va) + u.x*u.y*(va-vb-vc+vd),   // value
                 ga + u.x*(gb-ga) + u.y*(gc-ga) + u.x*u.y*(ga-gb-gc+gd) +  // derivatives
                 du * (u.yx*(va-vb-vc+vd) + float2(vb,vc) - va));
}

// return value noise (in x) and its derivatives (in yzw)
float4 noised( in float3 x )
{
    // grid
    float3 p = floor(x);
    float3 w = frac(x);
    
    #if 1
    // quintic interpolant
    float3 u = w*w*w*(w*(w*6.0-15.0)+10.0);
    float3 du = 30.0*w*w*(w*(w-2.0)+1.0);
    #else
    // cubic interpolant
    float3 u = w*w*(3.0-2.0*w);
    float3 du = 6.0*w*(1.0-w);
    #endif    
    
    // gradients
    float3 ga = hash33( p+float3(0.0,0.0,0.0) );
    float3 gb = hash33( p+float3(1.0,0.0,0.0) );
    float3 gc = hash33( p+float3(0.0,1.0,0.0) );
    float3 gd = hash33( p+float3(1.0,1.0,0.0) );
    float3 ge = hash33( p+float3(0.0,0.0,1.0) );
    float3 gf = hash33( p+float3(1.0,0.0,1.0) );
    float3 gg = hash33( p+float3(0.0,1.0,1.0) );
    float3 gh = hash33( p+float3(1.0,1.0,1.0) );
    
    // projections
    float va = dot( ga, w-float3(0.0,0.0,0.0) );
    float vb = dot( gb, w-float3(1.0,0.0,0.0) );
    float vc = dot( gc, w-float3(0.0,1.0,0.0) );
    float vd = dot( gd, w-float3(1.0,1.0,0.0) );
    float ve = dot( ge, w-float3(0.0,0.0,1.0) );
    float vf = dot( gf, w-float3(1.0,0.0,1.0) );
    float vg = dot( gg, w-float3(0.0,1.0,1.0) );
    float vh = dot( gh, w-float3(1.0,1.0,1.0) );
    
    // interpolations
    return float4( va + u.x*(vb-va) + u.y*(vc-va) + u.z*(ve-va) + u.x*u.y*(va-vb-vc+vd) + u.y*u.z*(va-vc-ve+vg) + u.z*u.x*(va-vb-ve+vf) + (-va+vb+vc-vd+ve-vf-vg+vh)*u.x*u.y*u.z,    // value
                 ga + u.x*(gb-ga) + u.y*(gc-ga) + u.z*(ge-ga) + u.x*u.y*(ga-gb-gc+gd) + u.y*u.z*(ga-gc-ge+gg) + u.z*u.x*(ga-gb-ge+gf) + (-ga+gb+gc-gd+ge-gf-gg+gh)*u.x*u.y*u.z +   // derivatives
                 du * (float3(vb,vc,ve) - va + u.yzx*float3(va-vb-vc+vd,va-vc-ve+vg,va-vb-ve+vf) + u.zxy*float3(va-vb-ve+vf,va-vb-vc+vd,va-vc-ve+vg) + u.yzx*u.zxy*(-va+vb+vc-vd+ve-vf-vg+vh) ));
}




#ifdef USING_TEXLOD_NOISE
//IQ fast noise3D https://www.shadertoy.com/view/ldScDh
float vnoise( in float3 x )
{
    float3 p = floor(x);
    float3 f = frac(x);
	f = f*f*(3.0-2.0*f);
	float2 uv = (p.xy+float2(37.0,17.0)*p.z) + f.xy;
	float2 rg = tex2Dlod( _NoiseTex, float4((uv+0.5)/256.0, 0.0,0.)).yx;
	return lerp( rg.x, rg.y, f.z );
}

//IQ fast noise2D https://www.shadertoy.com/view/XsX3RB
float vnoise( in float2 x )
{
    float2 p = floor(x);
    float2 f = frac(x);
	f = f*f*(3.0-2.0*f);
	float2 uv = p.xy+ + f.xy;
	return tex2Dlod( _NoiseTex, float4((uv+0.5)/256.0, 0.,0.) ).x;
} 
#else
float vnoise(float2 p)
{
    float2 pi = floor(p);
    float2 pf = p - pi;
    
    float2 w = pf * pf * (3.0 - 2.0 * pf);
    
    return lerp(lerp(hash21(pi + float2(0.0, 0.0)), hash21(pi + float2(1.0, 0.0)), w.x),
               lerp(hash21(pi + float2(0.0, 1.0)), hash21(pi + float2(1.0, 1.0)), w.x),
               w.y);
}


float vnoise(float3 p)
{
    float3 pi = floor(p);
    float3 pf = p - pi;
    
    float3 w = pf * pf * (3.0 - 2.0 * pf);
    
    return  lerp(
                lerp(
                    lerp(hash31(pi + float3(0, 0, 0)), hash31(pi + float3(1, 0, 0)), w.x),
                    lerp(hash31(pi + float3(0, 0, 1)), hash31(pi + float3(1, 0, 1)), w.x), 
                    w.z),
                lerp(
                    lerp(hash31(pi + float3(0, 1, 0)), hash31(pi + float3(1, 1, 0)), w.x),
                    lerp(hash31(pi + float3(0, 1, 1)), hash31(pi + float3(1, 1, 1)), w.x), 
                    w.z),
                w.y);
}
#endif


float snoise(float2 p)
{
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;
    
    float2 i = floor(p + (p.x + p.y) * K1);
    
    float2 a = p - (i - (i.x + i.y) * K2);
    float2 o = (a.x < a.y) ? float2(0.0, 1.0) : float2(1.0, 0.0);
    float2 b = a - (o - K2);
    float2 c = a - (1.0 - 2.0 * K2);
    
    float3 h = max(0.5 - float3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
    float3 n = h * h * h * h * float3(dot(a, hash22(i)), dot(b, hash22(i + o)), dot(c, hash22(i + 1.0)));
    
    return dot(float3(70.0, 70.0, 70.0), n);
}

float snoise(float3 p)
{
    const float K1 = 0.333333333;
    const float K2 = 0.166666667;
    
    float3 i = floor(p + (p.x + p.y + p.z) * K1);
    float3 d0 = p - (i - (i.x + i.y + i.z) * K2);
    
    // thx nikita: https://www.shadertoy.com/view/XsX3zB
    float3 e = step(float3(0.0,0.0,0.0), d0 - d0.yzx);
    float3 i1 = e * (1.0 - e.zxy);
    float3 i2 = 1.0 - e.zxy * (1.0 - e);
    
    float3 d1 = d0 - (i1 - 1.0 * K2);
    float3 d2 = d0 - (i2 - 2.0 * K2);
    float3 d3 = d0 - (1.0 - 3.0 * K2);
    
    float4 h = max(0.6 - float4(dot(d0, d0), dot(d1, d1), dot(d2, d2), dot(d3, d3)), 0.0);
    float4 n = h * h * h * h * float4(dot(d0, hash33(i)), dot(d1, hash33(i + i1)), dot(d2, hash33(i + i2)), dot(d3, hash33(i + 1.0)));
    
    return dot(float4(31.316,31.316,31.316,31.316), n);
}

float tri(in float x){return abs(frac(x)-.5);}
float2 tri2(in float2 p){return float2(tri(p.x+tri(p.y*2.)), tri(p.y+tri(p.x*2.)));}
float3 tri3(in float3 p){return float3(tri(p.z+tri(p.y*1.)), tri(p.z+tri(p.x*1.)), tri(p.y+tri(p.x*1.)));}

float tnoise(float2 p,float time,float spd)
{
	const float2x2 _m2 = float2x2( 0.970,  0.242, -0.242,  0.970 );
    float z=1.5;
	float rz = 0.;
    float2 bp = p;
	for (float i=0.; i<=4.; i++ )
	{
        float2 dg = tri2(bp*2.)*.8;
        p += (dg+time)*spd;

        bp *= 1.6;
		z *= 1.8;
		p *= 1.2;
        p = mul(_m2,p);
        
        rz+= (tri(p.x+tri(p.y)))/z;
	}
	return rz;
}

//https://www.shadertoy.com/view/4ts3z2 
float tnoise(in float3 p, float time,float spd)
{
    float z=1.4;
	float rz = 0.;
    float3 bp = p;
	for (float i=0.; i<=3.; i++ )
	{
        float3 dg = tri3(bp*2.);
        p += dg+time*spd;

        bp *= 1.8;
		z *= 1.5;
		p *= 1.2;
        
        rz+= (tri(p.z+tri(p.x+tri(p.y))))/z;
        bp += 0.14;
	}
	return rz;
}

//voronoi worleynoise
float wnoise(float2 p,float time) {
	float2 n = floor(p);
	float2 f = frac(p);
	float md = 5.0;
	float2 m = float2(0.,0.);
	for (int i = -1;i<=1;i++) {
		for (int j = -1;j<=1;j++) {
			float2 g = float2(i, j);
			float2 o = hash22(n+g);
			o = 0.5+0.5*sin(time+6.28*o);
			float2 r = g + o - f;
			float d = dot(r, r);
			if (d<md) {
				md = d;
				m = n+g+o;
			} 
		}
	}
	return md;
}
//3D version please ref to https://www.shadertoy.com/view/ldl3Dl
float3 wnoise( in float3 x ,float time)
{
    float3 p = floor( x );
    float3 f = frac( x );

    float id = 0.0;
    float2 res = float2( 100.0,100.0 );
    for( int k=-1; k<=1; k++ )
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        float3 b = float3( float(i), float(j), float(k) );
		float3 o = hash33( p + b );
		o = 0.5+0.5*sin(time+6.28*o);
        float3 r = float3( b ) - f + o;
        float d = dot( r, r );

        if( d < res.x )
        {
            id = dot( p+b, float3(1.0,57.0,113.0 ) );
            res = float2( d, res.x );         
        }
        else if( d < res.y )
        {
            res.y = d;
        }
    }

    return float3( sqrt( res ), abs(id) );
}

float fbm( float2 p )
{
	const float2x2 m2 = float2x2( 0.80,  0.60, -0.60,  0.80 );
    float f = 0.0;

    f += 0.50000*noise( p ); p = mul(m2,p)*2.02;
    f += 0.25000*noise( p ); p = mul(m2,p)*2.03;
    f += 0.12500*noise( p ); p = mul(m2,p)*2.01;
    f += 0.06250*noise( p ); p = mul(m2,p)*2.04;
    f += 0.03125*noise( p );

    return f/0.984375;
}
float fbm( in float3 p )
{
    float n = 0.0;
    n += 0.50000*noise( p*1.0 );
    n += 0.25000*noise( p*2.0 );
    n += 0.12500*noise( p*4.0 );
    n += 0.06250*noise( p*8.0 );
    n += 0.03125*noise( p*16.0 );
    return n/0.984375;
}


float fbm4( in float3 p )
{
    float n = 0.0;
    n += 1.000*noise( p*1.0 );
    n += 0.500*noise( p*2.0 );
    n += 0.250*noise( p*4.0 );
    n += 0.125*noise( p*8.0 );
    return n;
}

float fbm6( in float3 p )
{
    float n = 0.0;
    n += 1.00000*noise( p*1.0 );
    n += 0.50000*noise( p*2.0 );
    n += 0.25000*noise( p*4.0 );
    n += 0.12500*noise( p*8.0 );
    n += 0.06250*noise( p*16.0 );
    n += 0.03125*noise( p*32.0 );
    return n;
}

float fbm4( in float2 p )
{
    float n = 0.0;
    n += 1.00000*noise( p*1.0 );
    n += 0.50000*noise( p*2.0 );
    n += 0.25000*noise( p*4.0 );
    n += 0.12500*noise( p*8.0 );
    return n;
}

float fbm6( in float2 p )
{
    float n = 0.0;
    n += 1.00000*noise( p*1.0 );
    n += 0.50000*noise( p*2.0 );
    n += 0.25000*noise( p*4.0 );
    n += 0.12500*noise( p*8.0 );
    n += 0.06250*noise( p*16.0 );
    n += 0.03125*noise( p*32.0 );
    return n;
}

/**/

#endif // FMST_NOISE
