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
Texture2D TextureSampler_tex : register(t0);

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

	float4 r0;
	float4 r1;
	r0.xyz = i.texcoord5.xyz + -(gViewInverse[3].xyz);
	r0.x = dot(r0.xyz, i.texcoord7.xyz);
	r0.yzw = -(i.texcoord4.xyz) + gViewInverse[3].xyz;
	r1.x = dot(r0.yzw, r0.yzw);
	r1.x = rsqrt(r1.x);
	r0.yzw = r0.yzw * r1.xxx;
	r1.x = dot(r0.yzw, i.texcoord7.xyz);
	r0.x = r0.x / r1.x;
	r0.xyz = r0.xxx * r0.yzw + gViewInverse[3].xyz;
	r0.xyz = r0.xyz + -(i.texcoord5.xyz);
	r0.w = dot(r0.xyz, i.texcoord6.xyz);
	r0.xyz = -(i.texcoord6.xyz) * r0.www + r0.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = sqrt(r0.x);
	r0.x = r0.x / i.texcoord5.w;
	r0.x = -(r0.x) * 0.5 + 0.5;
	r0.y = i.texcoord.y;
	r0.x = TextureSampler_tex.Sample(TextureSampler, r0.xy).x;
	r0.x = saturate(r0.x + -0.100000001);
	r0.yzw = i.color.xyz + float3(0.00100000005, 0.00100000005, 0.00100000005);
	r1.xyz = r0.yzw * i.color.www;
	r1.w = i.color.w;
	r0 = r0.x * r1;
	r1.x = log2(i.texcoord7.w);
	r1.x = r1.x * vCustomData[3].w;
	r1.x = exp2(r1.x);
	o = r0 * r1.x;

	return o;
}
