cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer PtxGPUAttribs : register(b1)
{
	float gMotionBlur : packoffset(c0);
	float4 gRadius : packoffset(c1);
	float2 gLifeFade : packoffset(c2);
	float4 gTextureAnimation : packoffset(c3);
	float4 gColorTint : packoffset(c4);
	float4 gColorTintPhase2 : packoffset(c5);
};

struct VS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.x = asint(i.texcoord.x * 100);
	r0.x = (uint)asfloat(r0.x);
	r0.x = r0.x & 31;
	r0.x = asint((float)(uint)r0.x);
	r0.x = asint(asfloat(r0.x) * 0.03125);
	r0.y = (i.texcoord1.w == 0) ? -1 : 0;
	if (r0.y != 0) {
		r0.y = asint(gRadius.y * asfloat(r0.x) + gRadius.x);
		r0.z = asint(i.texcoord2.x + -0.5);
		r0.w = asint(dot(i.texcoord1.xyz, i.texcoord1.xyz));
		r0.w = asint(rsqrt(asfloat(r0.w)));
		r1.xyz = asfloat(r0.www) * i.texcoord1.xyz;
		r2.xyz = -(i.texcoord.yzx) + gViewInverse[3].yzx;
		r3 = r1.zxy * r2.xyz;
		r2.xyz = r1.yzx * r2.yzx + -(r3.xyz);
		r0.w = asint(dot(r2.xyz, r2.xyz));
		r0.w = asint(rsqrt(asfloat(r0.w)));
		r2.xyz = asfloat(r0.www) * r2.xyz;
		r3 = i.texcoord1.xyz * gMotionBlur;
		r1.xyz = asfloat(r0.yyy) * r1.xyz + r3.xyz;
		r2.xyz = asfloat(r0.yyy) * r2.xyz;
		r0.y = asint(-(i.texcoord2.y) + 0.699999988);
		r1.xyz = -(r1.xyz) * asfloat(r0.yyy);
		r0.yzw = asint(asfloat(r0.zzz) * r2.xyz + r1.xyz);
		r0.yzw = asint(asfloat(r0.yzw) + i.texcoord.xyz);
		r1 = asfloat(r0.z) * gWorldViewProj[1];
		r1 = asfloat(r0.y) * gWorldViewProj[0] + r1;
		r1 = asfloat(r0.w) * gWorldViewProj[2] + r1;
		o.sv_position = r1 + gWorldViewProj[3];
		o.color = gColorTint;
		r1.x = i.texcoord2.x;
	} else {
		r0.x = asint(gRadius.w * asfloat(r0.x) + gRadius.z);
		r0.yz = asint(i.texcoord2.xy + float2(-0.5, -0.5));
		r0.w = asint(dot(gViewInverse[0].xyz, gViewInverse[0].xyz));
		r0.w = asint(rsqrt(asfloat(r0.w)));
		r2.xyz = asfloat(r0.www) * gViewInverse[0].xyz;
		r2.xyz = asfloat(r0.xxx) * r2.xyz;
		r0.w = asint(dot(-(gViewInverse[1].xyz), -(gViewInverse[1].xyz)));
		r0.w = asint(rsqrt(asfloat(r0.w)));
		r3 = asfloat(r0.www) * -(gViewInverse[1].xyz);
		r3 = asfloat(r0.xxx) * r3.xyz;
		r0.xzw = asint(asfloat(r0.zzz) * r3.xyz);
		r0.xyz = asint(asfloat(r0.yyy) * r2.xyz + asfloat(r0.xzw));
		r0.xyz = asint(asfloat(r0.xyz) + i.texcoord.xyz);
		r2 = asfloat(r0.y) * gWorldViewProj[1];
		r2 = asfloat(r0.x) * gWorldViewProj[0] + r2;
		r0 = asint(asfloat(r0.z) * gWorldViewProj[2] + r2);
		o.sv_position = asfloat(r0) + gWorldViewProj[3];
		r0.x = asint(i.texcoord.w * gTextureAnimation.x + -(gTextureAnimation.y));
		r0.x = asint(trunc(asfloat(r0.x)));
		r0.x = asint(saturate(asfloat(r0.x) * gTextureAnimation.z));
		r0.x = asint(gTextureAnimation.z * i.texcoord2.x + asfloat(r0.x));
		r1.x = asfloat(r0.x) + -10;
		o.color = gColorTintPhase2;
	}
	r1.y = i.texcoord2.y;
	o.texcoord = r1.xy;

	return o;
}
