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

cbuffer ParticleRainDrop : register(b1)
{
	float gNormalArc : packoffset(c0);
	float gLightIntensityClamp : packoffset(c0.y);
	float gDiffuse : packoffset(c0.z);
	float gAmbientAmount : packoffset(c0.w);
	float gSuperAlpha : packoffset(c1);
	float gBlurAmount : packoffset(c1.y);
	float gRefraction : packoffset(c1.z);
	float gNormalHeight : packoffset(c1.w);
	float SpecularPower : packoffset(c2);
	float gShadowAmount : packoffset(c2.y);
	float2 gHeatHazeRippleRate : packoffset(c2.z);
	float2 gHeatHazeRippleLength : packoffset(c3);
};

SamplerState DiffuseTexSampler : register(s0);
SamplerState FrameMapTexSampler : register(s1);
Texture2D DiffuseTexSampler_tex : register(t0);
Texture2D FrameMapTexSampler_tex : register(t1);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord8 : TEXCOORD8;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = i.texcoord3.xy / i.texcoord3.zz;
	r0.z = r0.x + i.texcoord3.w;
	r0.z = r0.z * gHeatHazeRippleRate.x;
	r0.z = r0.z * 10;
	r0.z = sin(r0.z);
	r0.z = r0.z * gHeatHazeRippleLength.x;
	r0.xw = r0.xy + float2(1, 1);
	r0.y = -(r0.y) + i.texcoord3.w;
	r0.y = r0.y * gHeatHazeRippleRate.y;
	r0.xy = r0.xy * float2(0.5, 10);
	r0.y = cos(r0.y);
	r0.y = r0.y * gHeatHazeRippleLength.y;
	r0.yz = r0.yz * globalScreenSize.wz;
	r0.w = -(r0.w) * 0.5 + 1;
	r1.y = r0.y * gRefraction + r0.w;
	r1.x = r0.z * gRefraction + r0.x;
	r0 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r1.xy);
	r2 = gBlurAmount * float4(-0.00326212007, -0.00405809982, -0.00695913984, 0.00457136985) + r1.xyxy;
	r3 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r2.xy);
	r2 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r2.zw);
	r0.xyz = r0.xyz + r3.xyz;
	r0.xyz = r2.xyz + r0.xyz;
	r2 = gBlurAmount * float4(-0.00203344994, 0.00620716019, 0.00962339994, -0.00194982998) + r1.xyxy;
	r3 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r2.xy);
	r2 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r2.zw);
	r0.xyz = r0.xyz + r3.xyz;
	r0.xyz = r2.xyz + r0.xyz;
	r2 = gBlurAmount * float4(0.00519456016, 0.00767021999, 0.00185461005, -0.00893124007) + r1.xyxy;
	r1 = gBlurAmount * float4(0.00896419957, 0.00412457995, -0.00791558996, -0.00597710023) + r1.xyxy;
	r3 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r2.xy);
	r2 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r2.zw);
	r0.xyz = r0.xyz + r3.xyz;
	r0.xyz = r2.xyz + r0.xyz;
	r2 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r1.xy);
	r1 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r1.zw);
	r0.xyz = r0.xyz + r2.xyz;
	r0.xyz = r1.xyz + r0.xyz;
	r0.xyz = r0.xyz * i.texcoord.xyz;
	r0.xyz = r0.xyz * float3(0.125, 0.125, 0.125);
	r1.x = saturate(i.texcoord3.x);
	r2 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord1.zw);
	r3 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord1.xy);
	r1.y = r2.w + -(r3.w);
	r1.x = r1.x * r1.y + r3.w;
	r0.w = saturate(r1.x * i.texcoord.w);
	o = max(r0, float4(0, 0, 0, 0));

	return o;
}
