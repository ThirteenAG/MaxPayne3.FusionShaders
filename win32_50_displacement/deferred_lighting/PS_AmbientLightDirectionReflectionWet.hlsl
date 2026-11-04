cbuffer _Globals : register(b4)
{
	float g_fSSAOBilateralCoef : packoffset(c130);
	float g_fVolumetricLightRayIntensityMult : packoffset(c131);
	float4 dReflectionParams : packoffset(c132);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

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

cbuffer DeferredLight : register(b7)
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

Texture2D deferredLightTexture0P : register(t3);
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D<uint4> gbufferStencilTexture : register(t11);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	float3 r3;
	float3 r4;
	float3 r5;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r1.x = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = asint(asfloat(r1.x) * i.texcoord1.w);
	r1.x = asint(1 / asfloat(r1.x));
	r1.yzw = asint(-(i.texcoord1.xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	r2.xyz = -(i.texcoord1.xyz) * asfloat(r1.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.xyz = asint(-(asfloat(r1.yzw)) + gViewInverse[3].xyz);
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r3 = gbufferTexture1.Load(r0.xyw).xyz;
	r3 = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r1.w = asint(dot(r3.xyz, r3.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r3 = asfloat(r1.www) * r3.xyz;
	r1.x = asint(dot(asfloat(r1.xyz), r3.xyz));
	r1.x = asint(-(abs(asfloat(r1.x))) + 1);
	r1.x = asint(max(asfloat(r1.x), 0));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r1.y = asint(asfloat(r1.x) * asfloat(r1.x));
	r1.y = asint(asfloat(r1.y) * asfloat(r1.y));
	r1.x = asint(asfloat(r1.y) * asfloat(r1.x));
	r1.x = asint(asfloat(r1.x) * 0.800000012 + 0.200000003);
	r1.y = gbufferStencilTexture.Load(r0.xyw).y;
	r1.zw = r1.yy & int2(8, 64);
	r1.w = ~r1.w;
	r1.z = (r1.z == 8) ? -1 : 0;
	r4 = (r1.zzz != 0) ? float3(0, 0, 0) : gDirectionalColour.xyz;
	r1.y = r1.w & r1.y;
	r1.z = asint(saturate(r3.z * 4));
	r1.z = asint(asfloat(r1.z) * dReflectionParams.y);
	r1.y = (r1.y != 0) ? 0 : r1.z;
	r5 = gbufferTexture2.Load(r0.xyw).xyz;
	r1.z = asint(r5.y * r5.y);
	r1.z = asint(asfloat(r1.z) * asfloat(r1.z));
	r1.w = asint(-(asfloat(r1.z)) * 196 + 512);
	r1.zw = asint(asfloat(r1.zw) * float2(196, 0.001953125));
	r1.w = asint(max(asfloat(r1.w), 0));
	r1.w = asint(asfloat(r1.y) * asfloat(r1.w));
	r1.w = asint(asfloat(r1.x) * asfloat(r1.w));
	r1.z = asint(asfloat(r1.w) * 512 + asfloat(r1.z));
	r1.z = asint(asfloat(r1.z) + 0.00000999999975);
	r1.w = asint(dot(r2.xyz, r2.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xyz = asfloat(r1.www) * r2.xyz;
	r1.w = asint(dot(r2.xyz, r3.xyz));
	r1.w = asint(asfloat(r1.w) + asfloat(r1.w));
	r2.xyz = r3.xyz * -(asfloat(r1.www)) + r2.xyz;
	r1.w = asint(saturate(dot(-(gDirectionalLight.xyz), r2.xyz)));
	r1.w = asint(asfloat(r1.w) + 0.00000999999975);
	r1.w = asint(log2(asfloat(r1.w)));
	r1.z = asint(asfloat(r1.w) * asfloat(r1.z));
	r1.z = asint(exp2(asfloat(r1.z)));
	r1.w = asint(dot(r3.xyz, -(gDirectionalLight.xyz)));
	r2.x = saturate(asfloat(r1.w) * 2 + -0.5);
	r1.w = asint(saturate(asfloat(r1.w) + -0.25));
	r1.w = asint(asfloat(r1.w) * 1.33333337);
	r2.yzw = asfloat(r1.www) * r4.xyz;
	r1.z = asint(asfloat(r1.z) * r2.x);
	r4 = asfloat(r1.zzz) * r4.xyz;
	r1.z = asint(saturate(-(r5.x) + 1));
	r1.y = asint(asfloat(r1.y) * asfloat(r1.z));
	r1.x = asint(asfloat(r1.y) * asfloat(r1.x) + r5.x);
	r1.y = asint(dot(gLightAmbientDir1.xyz, r3.xyz));
	r1.z = asint(dot(gLightAmbientDir0.xyz, r3.xyz));
	r1.yz = asint(saturate(asfloat(r1.yz) + gLightAmbientDir0.ww));
	r3 = asfloat(r1.yyy) * gLightAmbient1.xyz;
	r1.yzw = asint(asfloat(r1.zzz) * gLightAmbient0.xyz + r3.xyz);
	r1.yzw = asint(r5.zzz * asfloat(r1.yzw));
	r2.x = sqrt(r5.z);
	r1.yzw = asint(r2.yzw * r2.xxx + asfloat(r1.yzw));
	r2.x = dot(asfloat(r1.yzw), float3(0.333333343, 0.333333343, 0.333333343));
	r2.x = r2.x + 0.0149999997;
	r2.yzw = deferredLightTexture0P.Load(r0.xyz).xyz;
	r0.xyz = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r2.yzw = r2.yzw * r2.yzw;
	r2.yzw = r2.yzw * float3(16, 16, 16);
	r2.xyz = r2.xxx * r2.yzw;
	r2.xyz = r4.xyz * asfloat(r1.xxx) + r2.xyz;
	o.xyz = asfloat(r0.xyz) * asfloat(r1.yzw) + r2.xyz;
	o.w = 1;

	return o;
}
