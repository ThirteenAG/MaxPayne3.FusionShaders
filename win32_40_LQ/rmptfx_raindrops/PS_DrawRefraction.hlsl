cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
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
};

SamplerState DiffuseTexSampler : register(s0);
SamplerState FrameMapTexSampler : register(s1);
SamplerState NormalMapTexSampler : register(s2);
Texture2D DiffuseTexSampler_tex : register(t0);
Texture2D FrameMapTexSampler_tex : register(t1);
Texture2D NormalMapTexSampler_tex : register(t2);

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
	float4 r4;
	r0.x = gRefraction * 10;
	r1.x = sin(i.texcoord3.z);
	r2.x = cos(i.texcoord3.z);
	r3 = NormalMapTexSampler_tex.Sample(NormalMapTexSampler, i.texcoord2.xy);
	r0.yzw = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r1.xy = r1.xx * r0.zy;
	r0.y = r0.y * r2.x + -(r1.x);
	r0.z = r0.z * r2.x + r1.y;
	r1.xy = r0.xx * r0.yz;
	r1.z = r0.w * gNormalHeight;
	r0.xyz = r0.xxx * r0.yzw;
	r0.xyz = r0.xyz * gNormalHeight + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.xy = r1.zz * r1.xy;
	r0.w = r1.x * globalScreenSize.z;
	r1.xz = i.texcoord3.xy + float2(1, 1);
	r2.x = r1.x * 0.5 + r0.w;
	r0.w = -(r1.z) * 0.5 + 1;
	r2.y = r1.y * globalScreenSize.w + r0.w;
	r1.xy = gBlurAmount * float2(-0.00326212007, -0.00405809982) + r2.xy;
	r1 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r1.xy);
	r3 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r2.xy);
	r1.xyz = r1.xyz + r3.xyz;
	r3 = gBlurAmount * float4(-0.00695913984, 0.00457136985, -0.00203344994, 0.00620716019) + r2.xyxy;
	r4 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r3.xy);
	r3 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r3.zw);
	r1.xyz = r1.xyz + r4.xyz;
	r1.xyz = r3.xyz + r1.xyz;
	r3 = gBlurAmount * float4(0.00962339994, -0.00194982998, 0.00519456016, 0.00767021999) + r2.xyxy;
	r4 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r3.xy);
	r3 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r3.zw);
	r1.xyz = r1.xyz + r4.xyz;
	r1.xyz = r3.xyz + r1.xyz;
	r3 = gBlurAmount * float4(0.00185461005, -0.00893124007, 0.00896419957, 0.00412457995) + r2.xyxy;
	r2.xy = gBlurAmount * float2(-0.00791558996, -0.00597710023) + r2.xy;
	r2 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r2.xy);
	r4 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r3.xy);
	r3 = FrameMapTexSampler_tex.Sample(FrameMapTexSampler, r3.zw);
	r1.xyz = r1.xyz + r4.xyz;
	r1.xyz = r3.xyz + r1.xyz;
	r1.xyz = r2.xyz + r1.xyz;
	r1.xyz = r1.xyz * i.texcoord.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r0.x = dot(r0.xyz, -(gDirectionalLight.xyz));
	r0.x = max(r0.x, -(gLightIntensityClamp));
	r0.x = min(r0.x, gLightIntensityClamp);
	r0.y = -(r0.x) + 1;
	r0.x = gNormalArc * r0.y + r0.x;
	r0.y = abs(r0.x) + 0.00000999999975;
	r0.x = r0.x * gDirectionalColour.x;
	r0.x = r0.x * gShadowAmount;
	r0.x = min(r0.x, 0);
	r0.y = log2(r0.y);
	r0.z = SpecularPower + 0.00000999999975;
	r0.y = r0.y * r0.z;
	r0.y = exp2(r0.y);
	r0.y = r0.y * gDirectionalColour.x;
	r0.y = r0.y * gDiffuse;
	r0.yzw = r1.xyz * float3(0.125, 0.125, 0.125) + r0.yyy;
	r0.xyz = r0.xxx + r0.yzw;
	r1.x = saturate(i.texcoord3.x);
	r2 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord1.zw);
	r3 = DiffuseTexSampler_tex.Sample(DiffuseTexSampler, i.texcoord1.xy);
	r1.y = r2.w + -(r3.w);
	r1.x = r1.x * r1.y + r3.w;
	r0.w = saturate(r1.x * i.texcoord.w);
	o = max(r0, float4(0, 0, 0, 0));

	return o;
}
