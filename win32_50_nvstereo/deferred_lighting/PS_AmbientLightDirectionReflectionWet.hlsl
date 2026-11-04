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

SamplerState StereoParmsTex : register(s9);
Texture2D<uint4> gbufferStencilTexture : register(t2);
Texture2D deferredLightTexture0P : register(t3);
Texture2D gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
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
	int4 r2;
	float4 r3;
	float4 r4;
	int3 r5;
	float3 r6;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r1.y = gbufferStencilTexture.Load(r0.xyw).y;
	r2.xyz = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r3.xyz = gbufferTexture2.Load(r0.xyw).xyz;
	r4.xyz = gbufferTexture1.Load(r0.xyw).xyz;
	r0.xyz = asint(deferredLightTexture0P.Load(r0.xyz).xyz);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * float3(16, 16, 16));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord1.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r1.zw = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy);
		r1.x = asint(-(asfloat(r1.w)) + asfloat(r1.x));
		r1.x = asint(asfloat(r1.x) * asfloat(r1.z));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r1.xzw = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r5 = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz);
		r1.xzw = asint(asfloat(r5.xyz) + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord1.w);
	r0.w = asint(1 / asfloat(r0.w));
	r1.xzw = asint(-(i.texcoord1.xyz) * asfloat(r0.www) + asfloat(r1.xzw));
	r5.xy = r1.yy & int2(8, 64);
	r0.w = (r5.x == 8) ? -1 : 0;
	r2.w = ~r5.y;
	r1.y = r1.y & r2.w;
	r2.w = asint(r3.y * r3.y);
	r2 = asint(asfloat(r2) * asfloat(r2));
	r3.y = asfloat(r2.w) * 196;
	r4.xyz = r4.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r3.w = dot(r4.xyz, r4.xyz);
	r3.w = rsqrt(r3.w);
	r4.xyz = r3.www * r4.xyz;
	r3.w = saturate(r4.z * 4);
	r3.w = r3.w * dReflectionParams.y;
	r1.y = (r1.y != 0) ? 0 : asint(r3.w);
	r5 = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz);
	r5 = asint(asfloat(r5.xyz) + gViewInverse[3].xyz);
	r6 = -(asfloat(r1.xzw)) + asfloat(r5.xyz);
	r3.w = dot(r6.xyz, r6.xyz);
	r3.w = rsqrt(r3.w);
	r6 = r3.www * r6.xyz;
	r3.w = dot(r6.xyz, r4.xyz);
	r3.w = -(abs(r3.w)) + 1;
	r3.w = max(r3.w, 0);
	r3.w = r3.w + 0.00000999999975;
	r4.w = r3.w * r3.w;
	r4.w = r4.w * r4.w;
	r3.w = r3.w * r4.w;
	r3.w = r3.w * 0.800000012 + 0.200000003;
	r4.w = saturate(-(r3.x) + 1);
	r4.w = asfloat(r1.y) * r4.w;
	r3.x = r4.w * r3.w + r3.x;
	r2.w = asint(-(asfloat(r2.w)) * 196 + 512);
	r2.w = asint(asfloat(r2.w) * 0.001953125);
	r2.w = asint(max(asfloat(r2.w), 0));
	r1.y = asint(asfloat(r1.y) * asfloat(r2.w));
	r1.y = asint(r3.w * asfloat(r1.y));
	r1.y = asint(asfloat(r1.y) * 512 + r3.y);
	r1.xzw = asint(asfloat(r1.xzw) + -(asfloat(r5.xyz)));
	r1 = asint(asfloat(r1) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.w = asint(dot(asfloat(r1.xzw), asfloat(r1.xzw)));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r1.xzw = asint(asfloat(r1.xzw) * asfloat(r2.www));
	r2.w = asint(dot(asfloat(r1.xzw), r4.xyz));
	r2.w = asint(asfloat(r2.w) + asfloat(r2.w));
	r1.xzw = asint(r4.xyz * -(asfloat(r2.www)) + asfloat(r1.xzw));
	r5 = (r0.www != 0) ? int3(0, 0, 0) : asint(gDirectionalColour.xyz);
	r0.w = asint(dot(r4.xyz, -(gDirectionalLight.xyz)));
	r2.w = asint(saturate(asfloat(r0.w) + -0.25));
	r2.w = asint(asfloat(r2.w) * 1.33333337);
	r1.x = asint(saturate(dot(-(gDirectionalLight.xyz), asfloat(r1.xzw))));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) * asfloat(r1.y));
	r1.x = asint(exp2(asfloat(r1.x)));
	r0.w = asint(saturate(asfloat(r0.w) * 2 + -0.5));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r5.xyz));
	r5 = asint(asfloat(r2.www) * asfloat(r5.xyz));
	r0.w = asint(sqrt(r3.z));
	r1.w = asint(dot(gLightAmbientDir0.xyz, r4.xyz));
	r1.w = asint(saturate(asfloat(r1.w) + gLightAmbientDir0.w));
	r2.w = asint(dot(gLightAmbientDir1.xyz, r4.xyz));
	r2.w = asint(saturate(asfloat(r2.w) + gLightAmbientDir0.w));
	r4.xyz = asfloat(r2.www) * gLightAmbient1.xyz;
	r4.xyz = asfloat(r1.www) * gLightAmbient0.xyz + r4.xyz;
	r3.yzw = r3.zzz * r4.xyz;
	r3.yzw = asfloat(r5.xyz) * asfloat(r0.www) + r3.yzw;
	r0.w = asint(dot(r3.yzw, float3(0.333333343, 0.333333343, 0.333333343)));
	r0.w = asint(asfloat(r0.w) + 0.0149999997);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r1.xyz) * r3.xxx + asfloat(r0.xyz));
	o.xyz = asfloat(r2.xyz) * r3.yzw + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
