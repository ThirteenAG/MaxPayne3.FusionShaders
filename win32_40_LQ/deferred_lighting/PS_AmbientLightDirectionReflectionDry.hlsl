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
	float4 r3;
	int4 r4;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw));
	r1.yzw = asint(float3(0, 0, 1));
	r1.x = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = asint(asfloat(r1.x) * i.texcoord1.w);
	r1.x = asint(1 / asfloat(r1.x));
	r1.xyz = asint(-(i.texcoord1.xyz) * asfloat(r1.xxx) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r2 = gbufferTexture1.Load(r0.xyw);
	r2.xyz = r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r1.w = asint(dot(r2.xyz, r2.xyz));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xyz = asfloat(r1.www) * r2.xyz;
	r1.w = asint(dot(asfloat(r1.xyz), r2.xyz));
	r1.w = asint(asfloat(r1.w) + asfloat(r1.w));
	r1.xyz = asint(r2.xyz * -(asfloat(r1.www)) + asfloat(r1.xyz));
	r1.x = asint(saturate(dot(-(gDirectionalLight.xyz), asfloat(r1.xyz))));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r3 = gbufferTexture2.Load(r0.xyw);
	r1.y = asint(r3.y * r3.y);
	r1.y = asint(asfloat(r1.y) * asfloat(r1.y));
	r1.y = asint(asfloat(r1.y) * 196 + 0.00000999999975);
	r1.x = asint(asfloat(r1.x) * asfloat(r1.y));
	r1.x = asint(exp2(asfloat(r1.x)));
	r1.y = asint(dot(r2.xyz, -(gDirectionalLight.xyz)));
	r1.z = asint(saturate(asfloat(r1.y) * 2 + -0.5));
	r1.y = asint(saturate(asfloat(r1.y) + -0.25));
	r1.y = asint(asfloat(r1.y) * 1.33333337);
	r1.x = asint(asfloat(r1.z) * asfloat(r1.x));
	r4 = gbufferStencilTexture.Load(r0.xyw);
	r1.z = r4.y & 8;
	r1.z = (r1.z == 8) ? -1 : 0;
	r4.xyz = (r1.zzz != 0) ? int3(0, 0, 0) : asint(gDirectionalColour.xyz);
	r1.xzw = asint(asfloat(r1.xxx) * asfloat(r4.xyz));
	r4.xyz = asint(asfloat(r1.yyy) * asfloat(r4.xyz));
	r1.y = asint(dot(gLightAmbientDir1.xyz, r2.xyz));
	r2.x = dot(gLightAmbientDir0.xyz, r2.xyz);
	r2.x = saturate(r2.x + gLightAmbientDir0.w);
	r1.y = asint(saturate(asfloat(r1.y) + gLightAmbientDir0.w));
	r2.yzw = asfloat(r1.yyy) * gLightAmbient1.xyz;
	r2.xyz = r2.xxx * gLightAmbient0.xyz + r2.yzw;
	r2.xyz = r3.zzz * r2.xyz;
	r1.y = asint(sqrt(r3.z));
	r2.xyz = asfloat(r4.xyz) * asfloat(r1.yyy) + r2.xyz;
	r1.y = asint(dot(r2.xyz, float3(0.333333343, 0.333333343, 0.333333343)));
	r1.y = asint(asfloat(r1.y) + 0.0149999997);
	r4 = asint(deferredLightTexture0P.Load(r0.xyz));
	r0 = asint(gbufferTexture0.Load(r0.xyw));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r3.yzw = asfloat(r4.xyz) * asfloat(r4.xyz);
	r3.yzw = r3.yzw * float3(16, 16, 16);
	r3.yzw = asfloat(r1.yyy) * r3.yzw;
	r1.xyz = asint(asfloat(r1.xzw) * r3.xxx + r3.yzw);
	o.xyz = asfloat(r0.xyz) * r2.xyz + asfloat(r1.xyz);
	o.w = 1;

	return o;
}
