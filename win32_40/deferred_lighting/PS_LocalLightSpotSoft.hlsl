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

Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);

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
	float3 r2;
	float4 r3;
	float3 r4;
	float4 r5;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xyw);
	r1.yzw = float3(0, 0, 1);
	r1.x = r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w);
	r1.x = r1.x * i.texcoord.w;
	r1.x = 1 / r1.x;
	r1.yzw = -(i.texcoord.xyz) * r1.xxx + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2 = -(i.texcoord.xyz) * r1.xxx + gViewInverse[3].xyz;
	r2 = -(r2.xyz) + i.texcoord2.xyz;
	r1.x = dot(r1.yzw, r1.yzw);
	r1.x = rsqrt(r1.x);
	r1.xyz = r1.xxx * r1.yzw;
	r3 = gbufferTexture1.Load(r0.xyz);
	r3.xyz = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.z = asint(dot(r3.xyz, r3.xyz));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r3.xyz = asfloat(r0.zzz) * r3.xyz;
	r0.z = asint(dot(r1.xyz, r3.xyz));
	r0.z = asint(asfloat(r0.z) + asfloat(r0.z));
	r1.xyz = r3.xyz * -(asfloat(r0.zzz)) + r1.xyz;
	r4 = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.z = asint(dot(r2.xyz, r2.xyz));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r0.z = asint(saturate(-(asfloat(r0.z)) * gDeferredLightRadiusProjShearParams.y + 1));
	r2 = asfloat(r0.zzz) * i.texcoord4.xyz;
	r0.z = asint(dot(r4.xyz, r4.xyz));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r4 = asfloat(r0.zzz) * r4.xyz;
	r0.z = asint(saturate(dot(r4.xyz, r1.xyz)));
	r0.z = asint(asfloat(r0.z) + 0.00000999999975);
	r0.z = asint(log2(asfloat(r0.z)));
	r1 = gbufferTexture2.Load(r0.xyw);
	r5 = gbufferTexture0.Load(r0.xyw);
	r0.xyw = asint(r5.xyz * r5.xyz);
	r1.y = r1.y * r1.y;
	r1.y = r1.y * r1.y;
	r1.y = r1.y * 196 + 0.00000999999975;
	r0.z = asint(asfloat(r0.z) * r1.y);
	r0.z = asint(exp2(asfloat(r0.z)));
	r1.y = dot(r4.xyz, r3.xyz);
	r1.z = dot(r4.xyz, i.texcoord3.xyz);
	r1.z = saturate(r1.z * i.texcoord1.w + i.texcoord1.z);
	r2 = r1.zzz * r2.xyz;
	r1.z = saturate(r1.y);
	r1.y = r1.y + 0.5;
	r1.y = saturate(r1.y * 0.25);
	r1.y = r1.z + r1.y;
	r1.z = saturate(r1.z * 2 + -0.5);
	r0.z = asint(asfloat(r0.z) * r1.z);
	r3.xyz = asfloat(r0.zzz) * r2.xyz;
	r1.yzw = r1.yyy * r2.xyz;
	r2 = r1.xxx * r3.xyz;
	o.xyz = asfloat(r0.xyw) * r1.yzw + r2.xyz;
	o.w = 1;

	return o;
}
