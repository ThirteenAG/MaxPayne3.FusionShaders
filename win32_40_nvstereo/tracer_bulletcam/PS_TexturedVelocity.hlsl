cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer TracerCommon : register(b1)
{
	float gHeatHazeScale : packoffset(c0);
	float gHeatHazeWidth : packoffset(c0.y);
	float gHeatHazeSize : packoffset(c0.z);
	float gLifeTimeScale : packoffset(c0.w);
	float gDistanceScale : packoffset(c1);
	float gTotalLifeTimeScale : packoffset(c1.y);
	float gDayNightScale : packoffset(c1.z);
	float4 vCustomData[4] : packoffset(c2);
};

SamplerState TextureSampler : register(s0);
SamplerState DownsampleDepthSampler : register(s2);
SamplerState NoiseMapSampler : register(s3);
Texture2D TextureSampler_tex : register(t0);
Texture2D DownsampleDepthSampler_tex : register(t2);
Texture2D NoiseMapSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float texcoord3 : TEXCOORD3;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float4 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float4 r2;
	r0.xyz = asint(i.texcoord5.xyz + -(gViewInverse[3].xyz));
	r0.x = asint(dot(asfloat(r0.xyz), i.texcoord7.xyz));
	r0.yzw = asint(-(i.texcoord4.xyz) + gViewInverse[3].xyz);
	r1.x = dot(asfloat(r0.yzw), asfloat(r0.yzw));
	r1.x = rsqrt(r1.x);
	r0.yzw = asint(asfloat(r0.yzw) * r1.xxx);
	r1.x = dot(asfloat(r0.yzw), i.texcoord7.xyz);
	r0.x = asint(asfloat(r0.x) / r1.x);
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r0.yzw) + gViewInverse[3].xyz);
	r0.xyz = asint(asfloat(r0.xyz) + -(i.texcoord5.xyz));
	r0.w = asint(dot(asfloat(r0.xyz), i.texcoord6.xyz));
	r0.xyz = asint(-(i.texcoord6.xyz) * asfloat(r0.www) + asfloat(r0.xyz));
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) / i.texcoord5.w);
	r0.x = asint(-(asfloat(r0.x)) * 0.5 + 0.5);
	r0.y = asint(i.texcoord.y);
	r0 = asint(TextureSampler_tex.Sample(TextureSampler, asfloat(r0.xy)));
	r0.y = asint(i.texcoord1.w + i.texcoord1.w);
	r0.y = asint(1 / asfloat(r0.y));
	r1.xy = i.texcoord1.xy * asfloat(r0.yy) + float2(0.5, 0.5);
	r1.z = -(r1.y) + 1;
	r2 = DownsampleDepthSampler_tex.Sample(DownsampleDepthSampler, r1.xz);
	r0.y = (i.texcoord3 >= -(r2.x)) ? -1 : 0;
	r0.y = r0.y & 1065353216;
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.y = asint(sin(vCustomData[2].x));
	r0.yz = asint(asfloat(r0.yy) + r1.xz);
	r0.yz = asint(asfloat(r0.yz) + asfloat(r0.yz));
	r1 = NoiseMapSampler_tex.Sample(NoiseMapSampler, asfloat(r0.yz));
	r0.y = asint(-(i.color.w) + 1);
	r0.y = asint(saturate(r1.x * asfloat(r0.y)));
	r1.xyz = r1.xyz * i.color.www;
	r0.z = asint(saturate(i.color.w));
	r0.y = asint(min(asfloat(r0.y), asfloat(r0.z)));
	r0.y = asint(-(asfloat(r0.y)) * 0.5 + asfloat(r0.z));
	r0.y = asint(asfloat(r0.y) * i.color.w);
	r1.w = saturate(asfloat(r0.y) * 2.5);
	r0 = asint(asfloat(r0.x) * r1);
	r1.x = log2(i.texcoord7.w);
	r1.x = r1.x * vCustomData[3].w;
	r1.x = exp2(r1.x);
	o = asfloat(r0) * r1.x;

	return o;
}
