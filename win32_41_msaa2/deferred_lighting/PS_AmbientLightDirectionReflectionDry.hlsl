cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
	float4 gDirectionalLight : packoffset(c1);
	float4 gDirectionalColour : packoffset(c2);
};

cbuffer omni_light : register(b2)
{
	float4 gLightPosX : packoffset(c0);
	float4 gLightPosY : packoffset(c1);
	float4 gLightPosZ : packoffset(c2);
	float4 gLightDirX : packoffset(c3);
	float4 gLightDirY : packoffset(c4);
	float4 gLightDirZ : packoffset(c5);
	float4 gLightFallOff : packoffset(c6);
	float4 gLightConeScale : packoffset(c7);
	float4 gLightConeOffset : packoffset(c8);
	float4 gLightColR : packoffset(c9);
	float4 gLightColG : packoffset(c10);
	float4 gLightColB : packoffset(c11);
	float4 gLightAmbient0 : packoffset(c12);
	float4 gLightAmbient1 : packoffset(c13);
	float4 gLightAmbientDir0 : packoffset(c14);
	float4 gLightAmbientDir1 : packoffset(c15);
};

cbuffer DeferredLight : register(b4)
{
	float gDeferredLightType : packoffset(c0);
	float3 gDeferredLightPosition : packoffset(c0.y);
	float3 gDeferredLightDirection : packoffset(c1);
	float3 gDeferredLightTangent : packoffset(c2);
	float4 gDeferredLightRadiusProjShearParams : packoffset(c3);
	float gDeferredLightInvSqrRadius : packoffset(c4);
	float gDeferredVolumeRadiusScale : packoffset(c4.y);
	float gDeferredLightConeAngleI : packoffset(c4.z);
	float gDeferredLightConeAngle : packoffset(c4.w);
	float gDeferredLightConeOffset : packoffset(c5);
	float gDeferredLightConeScale : packoffset(c5.y);
	float4 gDeferredLightColourAndIntensity : packoffset(c6);
	float4 gooDeferredLightScreenSize : packoffset(c7);
	float4 gDeferredProjParams : packoffset(c8);
};

Texture2DMS<float4> deferredLightTexture0P : register(t3);
Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2DMS<float> gbufferTextureDepth : register(t10);
Texture2DMS<uint4> gbufferStencilTexture : register(t11);
Texture2DMS<float4> gbufferTexture1 : register(t12);
Texture2DMS<float4> gbufferTexture2 : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	int4 r2;
	float3 r3;
	float3 r4;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x;
	r1.x = r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w);
	r1.x = r1.x * i.texcoord1.w;
	r1.x = 1 / r1.x;
	r1.xyz = -(i.texcoord1.xyz) * r1.xxx + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = rsqrt(r1.w);
	r1.xyz = r1.www * r1.xyz;
	r2.xyz = asint(gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz);
	r2.xyz = asint(asfloat(r2.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.w = dot(asfloat(r2.xyz), asfloat(r2.xyz));
	r1.w = rsqrt(r1.w);
	r2.xyz = asint(r1.www * asfloat(r2.xyz));
	r1.w = dot(r1.xyz, asfloat(r2.xyz));
	r1.w = r1.w + r1.w;
	r1.xyz = asfloat(r2.xyz) * -(r1.www) + r1.xyz;
	r1.x = saturate(dot(-(gDirectionalLight.xyz), r1.xyz));
	r1.x = r1.x + 0.00000999999975;
	r1.x = log2(r1.x);
	r1.yzw = gbufferTexture2.Load(r0.xy, i.sv_sampleindex).xyz;
	r1.z = r1.z * r1.z;
	r1.z = r1.z * r1.z;
	r1.z = r1.z * 196 + 0.00000999999975;
	r1.x = r1.x * r1.z;
	r1.x = exp2(r1.x);
	r1.z = dot(asfloat(r2.xyz), -(gDirectionalLight.xyz));
	r2.w = asint(saturate(r1.z * 2 + -0.5));
	r1.z = saturate(r1.z + -0.25);
	r1.z = r1.z * 1.33333337;
	r1.x = r1.x * asfloat(r2.w);
	r2.w = gbufferStencilTexture.Load(r0.xy, i.sv_sampleindex).y;
	r2.w = r2.w & 8;
	r2.w = (r2.w == 8) ? -1 : 0;
	r3 = (r2.www != 0) ? float3(0, 0, 0) : gDirectionalColour.xyz;
	r4 = r1.xxx * r3.xyz;
	r3 = r1.zzz * r3.xyz;
	r1.x = dot(gLightAmbientDir1.xyz, asfloat(r2.xyz));
	r1.z = dot(gLightAmbientDir0.xyz, asfloat(r2.xyz));
	r1.xz = saturate(r1.xz + gLightAmbientDir0.ww);
	r2.xyz = asint(r1.xxx * gLightAmbient1.xyz);
	r2.xyz = asint(r1.zzz * gLightAmbient0.xyz + asfloat(r2.xyz));
	r2.xyz = asint(r1.www * asfloat(r2.xyz));
	r1.x = sqrt(r1.w);
	r1.xzw = r3.xyz * r1.xxx + asfloat(r2.xyz);
	r2.x = asint(dot(r1.xzw, float3(0.333333343, 0.333333343, 0.333333343)));
	r2.x = asint(asfloat(r2.x) + 0.0149999997);
	r2.yzw = asint(deferredLightTexture0P.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r2.yzw = asint(asfloat(r2.yzw) * asfloat(r2.yzw));
	r2.yzw = asint(asfloat(r2.yzw) * float3(16, 16, 16));
	r2.xyz = asint(asfloat(r2.xxx) * asfloat(r2.yzw));
	r2.xyz = asint(r4.xyz * r1.yyy + asfloat(r2.xyz));
	o.xyz = asfloat(r0.xyz) * r1.xzw + asfloat(r2.xyz);
	o.w = 1;

	return o;
}
