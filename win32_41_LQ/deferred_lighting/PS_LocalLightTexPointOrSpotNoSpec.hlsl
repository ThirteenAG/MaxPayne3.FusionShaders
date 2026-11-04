cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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

SamplerState gDeferredLightSampler : register(s0);
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D gbufferTexture1 : register(t12);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xyw).x;
	r1.x = r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w);
	r1.x = r1.x * i.texcoord.w;
	r1.x = 1 / r1.x;
	r1.xyz = -(i.texcoord.xyz) * r1.xxx + gViewInverse[3].xyz;
	r2.xyz = -(r1.xyz) + i.texcoord2.xyz;
	r1.xyz = r1.xyz + -(i.texcoord2.xyz);
	r1.w = dot(r2.xyz, r2.xyz);
	r2.xyz = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = saturate(-(r1.w) * i.texcoord1.y + 1);
	r1.w = r1.w + 0.00000999999975;
	r1.w = log2(r1.w);
	r1.w = r1.w * 2.00001001;
	r1.w = exp2(r1.w);
	r1.w = r1.w + -0.333333343;
	r1.w = max(r1.w, 0);
	r1.w = r1.w * 1.5;
	r2.w = dot(r2.xyz, r2.xyz);
	r2.w = rsqrt(r2.w);
	r2.xyz = r2.www * r2.xyz;
	r2.w = dot(r2.xyz, i.texcoord3.xyz);
	r2.w = saturate(r2.w * i.texcoord1.w + i.texcoord1.z);
	r1.w = r1.w * r2.w;
	r3 = gbufferTexture1.Load(r0.xyz).xyz;
	r0.xyz = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r3 = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.w = asint(dot(r3.xyz, r3.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r3 = asfloat(r0.www) * r3.xyz;
	r0.w = asint(dot(r3.xyz, r2.xyz));
	r0.w = asint(asfloat(r0.w) + -0.200000003);
	r0.w = asint(saturate(asfloat(r0.w) * 1.25));
	r0.w = asint(asfloat(r0.w) * r1.w);
	r2.xyz = asfloat(r0.www) * i.texcoord4.xyz;
	r0.w = asint(dot(r1.xyz, r1.xyz));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r1.w = dot(-(gDeferredLightDirection.xyz), r1.xyz);
	r2.w = r1.w / asfloat(r0.w);
	r2.w = -(r2.w) + 1;
	r0.w = asint(asfloat(r0.w) * r2.w);
	r0.w = asint(1 / asfloat(r0.w));
	r3 = -(gDeferredLightDirection.zxy) * gDeferredLightTangent.yzx;
	r3 = -(gDeferredLightDirection.yzx) * gDeferredLightTangent.zxy + -(r3.xyz);
	r3.x = dot(r3.xyz, r1.xyz);
	r3.y = dot(gDeferredLightTangent.xyz, r1.xyz);
	r1.xy = asfloat(r0.ww) * r3.xy;
	r0.w = asint(abs(gDeferredLightConeOffset) + 60);
	r0.w = asint(120 / asfloat(r0.w));
	r0.w = asint(asfloat(r0.w) * gDeferredLightConeAngle);
	r0 = asint(asfloat(r0) * asfloat(r0));
	r0.w = asint(r1.w * asfloat(r0.w));
	r0.w = asint(-1 / asfloat(r0.w));
	r1.zw = asfloat(r0.ww) * r3.xy;
	r0.w = (gDeferredLightType == 2) ? -1 : 0;
	r1.xy = (r0.ww != 0) ? r1.zw : r1.xy;
	r1.xy = r1.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
	r1.xyz = gDeferredLightSampler_tex.SampleLevel(gDeferredLightSampler, r1.xy, 0).xyz;
	r0.xyz = asint(asfloat(r0.xyz) * r1.xyz);
	o.xyz = r2.xyz * asfloat(r0.xyz);
	o.w = 1;

	return o;
}
