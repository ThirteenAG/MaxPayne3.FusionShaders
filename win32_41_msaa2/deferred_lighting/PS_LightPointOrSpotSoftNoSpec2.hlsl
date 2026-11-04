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

Texture2DMS<float4> gbufferTexture0 : register(t8);
Texture2DMS<float> gbufferTextureDepth : register(t10);
Texture2DMS<uint4> gbufferStencilTexture : register(t11);
Texture2DMS<float4> gbufferTexture1 : register(t12);
Texture2DMS<float4> gbufferTexture2 : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	nointerpolation uint sv_sampleindex : SV_SampleIndex;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	float4 r1;
	float3 r2;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xy, i.sv_sampleindex).x;
	r1.x = r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w);
	r1.x = r1.x * i.texcoord.w;
	r1.x = 1 / r1.x;
	r1.xyz = -(i.texcoord.xyz) * r1.xxx + gViewInverse[3].xyz;
	r1.xyz = -(r1.xyz) + i.texcoord2.xyz;
	r2 = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = sqrt(r1.x);
	r1.x = saturate(-(r1.x) * gDeferredLightRadiusProjShearParams.y + 1);
	r1.y = dot(r2.xyz, r2.xyz);
	r1.y = rsqrt(r1.y);
	r1.yzw = r1.yyy * r2.xyz;
	r2 = gbufferTexture1.Load(r0.xy, i.sv_sampleindex).xyz;
	r2 = r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.z = asint(dot(r2.xyz, r2.xyz));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r2 = asfloat(r0.zzz) * r2.xyz;
	r0.z = asint(dot(r1.yzw, r2.xyz));
	r1.y = dot(r1.yzw, i.texcoord3.xyz);
	r1.y = saturate(r1.y * i.texcoord1.w + i.texcoord1.z);
	r1.x = r1.y * r1.x;
	r1.xyz = r1.xxx * i.texcoord4.xyz;
	r1.w = asfloat(r0.z) + 0.5;
	r0.z = asint(saturate(asfloat(r0.z)));
	r1.w = saturate(r1.w * 0.25);
	r0.z = asint(asfloat(r0.z) + r1.w);
	r1.xyz = asfloat(r0.zzz) * r1.xyz;
	r2 = gbufferTexture0.Load(r0.xy, i.sv_sampleindex).xyz;
	r2 = r2.xyz * r2.xyz;
	r1.xyz = r1.xyz * r2.xyz;
	r0.z = gbufferStencilTexture.Load(r0.xy, i.sv_sampleindex).y;
	r0.x = asint(gbufferTexture2.Load(r0.xy, i.sv_sampleindex).z);
	r0.x = asint(asfloat(r0.x) * asfloat(r0.x) + 0.5);
	r0.x = asint(min(asfloat(r0.x), 1));
	r0.y = r0.z & 8;
	r0.y = (r0.y == 8) ? -1 : 0;
	r0.x = (r0.y != 0) ? 0 : r0.x;
	o.xyz = asfloat(r0.xxx) * r1.xyz;
	o.w = 1;

	return o;
}
