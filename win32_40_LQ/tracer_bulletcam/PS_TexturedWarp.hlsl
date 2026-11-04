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
SamplerState BackBufferSampler : register(s1);
SamplerState NoiseMapSampler : register(s3);
Texture2D TextureSampler_tex : register(t0);
Texture2D BackBufferSampler_tex : register(t1);
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

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.x = i.texcoord2.w + i.texcoord2.w;
	r0.x = 1 / r0.x;
	r0.xy = i.texcoord2.xy * r0.xx + float2(0.5, 0.5);
	r0.z = -(r0.y) + 1;
	r0.y = i.texcoord1.w + i.texcoord1.w;
	r0.y = 1 / r0.y;
	r1.xy = i.texcoord1.xy * r0.yy + float2(0.5, 0.5);
	r1.z = -(r1.y) + 1;
	r0.xy = -(r0.zx) + r1.zx;
	r0.xy = r0.xy + float2(0.00000999999975, 0.00000999999975);
	r0.z = dot(r0.xy, r0.xy);
	r0.z = rsqrt(r0.z);
	r0.xy = r0.zz * r0.xy;
	r2 = TextureSampler_tex.Sample(TextureSampler, i.texcoord.xy);
	r0.z = saturate(r2.x + -0.100000001);
	r0.xy = r0.zz * r0.xy;
	r0.w = sin(vCustomData[2].x);
	r2 = r0.w + r1.xzxz;
	r2 = r2 * float4(7.19999981, 7.19999981, 4.80000019, 4.80000019);
	r3 = NoiseMapSampler_tex.Sample(NoiseMapSampler, r2.xy);
	r2 = NoiseMapSampler_tex.Sample(NoiseMapSampler, r2.zw);
	r1.yw = r2.yx + r3.yx;
	r1.yw = r1.yw * float2(0.00600000005, 0.00600000005);
	r0.xy = r0.xy * float2(0.150000006, 0.150000006) + r1.yw;
	r2 = r0.yxxy + r1.xzxz;
	r1 = BackBufferSampler_tex.Sample(BackBufferSampler, r1.xz);
	r3 = BackBufferSampler_tex.Sample(BackBufferSampler, r2.zw);
	r2 = BackBufferSampler_tex.Sample(BackBufferSampler, r2.xy);
	r0.x = -(r0.z) * 0.200000003 + 0.200000003;
	r0.y = r0.z * i.color.w;
	r0.y = saturate(r0.y * 5);
	r0.z = -(r0.x) + 1;
	r0.z = r0.z * 0.5;
	r3.xyz = r0.zzz * r3.xyz;
	r1.xyz = r1.xyz * r0.xxx + r3.xyz;
	o.xyz = r2.xyz * r0.zzz + r1.xyz;
	r0.x = log2(i.texcoord7.w);
	r0.x = r0.x * vCustomData[3].w;
	r0.x = exp2(r0.x);
	o.w = r0.x * r0.y;

	return o;
}
