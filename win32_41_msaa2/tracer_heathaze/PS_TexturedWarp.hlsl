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

SamplerState BackBufferSampler : register(s1);
SamplerState NoiseMapSampler : register(s3);
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
	float4 color : COLOR;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	float4 r3;
	float3 r4;
	r0.x = -(i.color.w) + 1;
	r0.y = sin(vCustomData[2].x);
	r0.y = r0.y + 0.300000012;
	r0.x = dot(r0.yy, r0.xx);
	r0.z = i.texcoord2.w + i.texcoord2.w;
	r0.z = 1 / r0.z;
	r1.xy = i.texcoord2.xy * r0.zz + float2(0.5, 0.5);
	r1.z = -(r1.y) + 1;
	r0.z = i.texcoord1.w + i.texcoord1.w;
	r0.z = 1 / r0.z;
	r2.xy = i.texcoord1.xy * r0.zz + float2(0.5, 0.5);
	r2.z = -(r2.y) + 1;
	r1.xy = -(r1.xz) + r2.xz;
	r1.xy = r1.xy + float2(0.00000999999975, 0.00000999999975);
	r0.w = dot(r1.xy, r1.xy);
	r0.w = rsqrt(r0.w);
	r1.zw = i.texcoord.xy + float2(-0.5, -0.5);
	r1.xy = r1.xy * r0.ww + r1.zw;
	r0.w = dot(r1.zw, r1.zw);
	r3 = r0.y * float4(6.5, 9, -26.7999992, 42.7000008) + r2.xzxz;
	r3 = r3 * float4(0.100000001, 0.100000001, 0.5, 0.5);
	r4 = NoiseMapSampler_tex.Sample(NoiseMapSampler, r3.xy).xyz;
	r1.zw = NoiseMapSampler_tex.Sample(NoiseMapSampler, r3.zw).xy;
	r1.zw = r1.wz + r4.yx;
	r0.y = r4.z + -0.5;
	r3.xy = r0.yy * float2(0.0500000007, 0.0500000007) + r1.xy;
	r1.xy = r1.zw * gHeatHazeWidth;
	r3.z = r0.x + r3.y;
	r1 = r3.xzzx * r1.yxxy + r2.xzxz;
	r2 = BackBufferSampler_tex.Sample(BackBufferSampler, r2.xz).xyz;
	r3.xyz = BackBufferSampler_tex.Sample(BackBufferSampler, r1.zw).xyz;
	r1.xyz = BackBufferSampler_tex.Sample(BackBufferSampler, r1.xy).xyz;
	r4.x = r0.z * i.texcoord1.x;
	r4.z = -(i.texcoord1.y) * r0.z + -0.5;
	r0.xy = r4.xz + float2(0, 0.5);
	r0.x = dot(r0.xy, r0.xy);
	r0.xw = sqrt(r0.xw);
	r0.y = r0.w * gHeatHazeSize;
	r0.z = -(r0.w) * gHeatHazeSize + r0.x;
	r0.z = r0.z + 0.800000012;
	o.w = saturate(r0.z * i.color.w);
	r0.y = r0.y * r0.y;
	r0.y = min(r0.y, 1);
	r0.y = r0.y + 0.00999999978;
	r0.x = saturate(-(r0.x) * 100 + r0.y);
	r0.y = -(r0.x) + 1;
	r0.y = r0.y * 0.5;
	r4 = i.color.xyz + float3(0.0500000007, 0.0500000007, 0.0500000007);
	r0.xzw = r2.xyz * r0.xxx + r4.xyz;
	r0.xzw = r3.xyz * r0.yyy + r0.xzw;
	r0.xyz = r1.xyz * r0.yyy + r0.xzw;
	o.xyz = r0.xyz * gHeatHazeScale;

	return o;
}
