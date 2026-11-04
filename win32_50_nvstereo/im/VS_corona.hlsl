cbuffer _Globals : register(b4)
{
	float ApparentDepth : packoffset(c205);
	float4 TransColor : packoffset(c207);
	float4 TransPos : packoffset(c208);
	float4 TransTex0 : packoffset(c209);
	float4 TexelSize : packoffset(c210);
	float GammaCorrection : packoffset(c211);
	float g_fBilateralCoefficient : packoffset(c212);
	float4 refMipBlurParams : packoffset(c213);
	float4 SubViewportParams : packoffset(c214);
	float MaskAlphaReverse : packoffset(c215);
	float InterlaceIndex : packoffset(c216);
	float StencilTech : packoffset(c217);
	float InterlaceTotalNum : packoffset(c218);
	float2 RedOff : packoffset(c219);
	float2 GreenOff : packoffset(c220);
	float2 BlueOff : packoffset(c221);
	float2 poisson12[12] : packoffset(c225);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
	float4 globalScreenSize : packoffset(c8);
};

SamplerState CoronasDepthMapSampler : register(s0);
SamplerState StereoParmsTex : register(s9);
Texture2D CoronasDepthMapSampler_tex : register(t0);
Texture2D StereoParmsTex_tex : register(t9);

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	r0.xyz = asint(i.position.xyz + -(i.normal.xyz));
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * 0.707106769);
	r0.yzw = asint(i.normal.xyz + -(gViewInverse[3].xyz));
	r1.x = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = (asfloat(r1.x) < asfloat(r0.x)) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(gWorldView[0].z);
		r1.y = asint(gWorldView[1].z);
		r1.z = asint(gWorldView[2].z);
		r0.y = asint(dot(asfloat(r1.xyz), asfloat(r0.yzw)));
		r0.z = (-(asfloat(r0.y)) < asfloat(r0.x)) ? -1 : 0;
		r0.x = asint(-(asfloat(r0.y)) / asfloat(r0.x));
		r0.x = asint(asfloat(r0.x) + 1);
		r2.w = asint(saturate(asfloat(r0.x) * 0.5));
		r0.x = (-(asfloat(r0.y)) < 0.100000001) ? -1 : 0;
		r0.y = asint(asfloat(r0.y) + 0.100000001);
		r1.xyz = asint(-(asfloat(r1.xyz)) * asfloat(r0.yyy) + i.position.xyz);
		r2.xyz = (r0.xxx != 0) ? r1.xyz : asint(i.position.xyz);
		r1.xyz = asint(i.position.xyz);
		r1.w = 1065353216;
		r0 = (r0.z != 0) ? r2 : r1;
	} else {
		r1 = asint(i.normal.y * gWorldViewProj[1]);
		r1 = asint(i.normal.x * gWorldViewProj[0] + asfloat(r1));
		r1 = asint(i.normal.z * gWorldViewProj[2] + asfloat(r1));
		r1 = asint(asfloat(r1) + gWorldViewProj[3]);
		r2.xy = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.25), 0).xy);
		r2.z = asint(asfloat(r1.w) + -(asfloat(r2.y)));
		r1.x = asint(asfloat(r2.x) * asfloat(r2.z) + asfloat(r1.x));
		r3.xyz = i.position.yyy * gWorldViewProj[1].xyw;
		r3.xyz = i.position.xxx * gWorldViewProj[0].xyw + r3.xyz;
		r3.xyz = i.position.zzz * gWorldViewProj[2].xyw + r3.xyz;
		r3.yzw = r3.xyz + gWorldViewProj[3].xyw;
		r2.y = asint(-(asfloat(r2.y)) + r3.w);
		r3.x = asfloat(r2.x) * asfloat(r2.y) + r3.y;
		r1.xyz = asint(asfloat(r1.xyz) / asfloat(r1.www));
		r2.xy = asint(r3.xz / r3.ww);
		r2.xy = asint(-(asfloat(r1.xy)) + asfloat(r2.xy));
		r2.xy = asint(asfloat(r2.xy) * globalScreenSize.xy);
		r1.w = asint(dot(asfloat(r2.xy), asfloat(r2.xy)));
		r1.w = asint(sqrt(asfloat(r1.w)));
		r1.w = asint(asfloat(r1.w) * 0.353553385);
		r1.w = asint(min(asfloat(r1.w), 32));
		r0.w = 0;
		r2.x = 0;
		while (true) {
			r2.y = (r2.x >= 12) ? -1 : 0;
			if (r2.y != 0) break;
			r2.yz = asint(globalScreenSize.zw * poisson12[r2.x].xy);
			r2.yz = asint(asfloat(r2.yz) * asfloat(r1.ww) + asfloat(r1.xy));
			r2.yz = asint(max(asfloat(r2.yz), float2(-0.996999979, -0.996999979)));
			r2.yz = asint(min(asfloat(r2.yz), float2(0.996999979, 0.996999979)));
			r2.yz = asint(asfloat(r2.yz) * float2(0.5, -0.5) + float2(0.5, 0.5));
			r2.y = asint(CoronasDepthMapSampler_tex.SampleLevel(CoronasDepthMapSampler, asfloat(r2.yz), 0).x);
			r2.y = (asfloat(r1.z) < asfloat(r2.y)) ? -1 : 0;
			r2.z = asint(asfloat(r0.w) + 0.0833333358);
			r0.w = (r2.y != 0) ? r2.z : r0.w;
			r2.x = r2.x + 1;
		}
		r1.x = (0.00999999978 < asfloat(r0.w)) ? -1 : 0;
		r0.xyz = asint((r1.xxx != 0) ? i.position.xyz : i.normal.xyz);
	}
	r1 = asint(asfloat(r0.y) * gWorldViewProj[1]);
	r1 = asint(asfloat(r0.x) * gWorldViewProj[0] + asfloat(r1));
	r1 = asint(asfloat(r0.z) * gWorldViewProj[2] + asfloat(r1));
	o.sv_position = asfloat(r1) + gWorldViewProj[3];
	r0.xyz = asint(asfloat(r0.www) * i.color.xyz);
	o.texcoord1.xyz = asfloat(r0.xyz) * i.texcoord.yyy;
	o.texcoord1.w = 1;
	o.texcoord.x = i.texcoord.x;
	o.texcoord.y = i.color.w;

	return o;
}
