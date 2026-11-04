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

SamplerState gDeferredLightShadowMap0 : register(s4);
Texture2D gDeferredLightShadowMap0_tex : register(t4);
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw));
	r1.yzw = asint(float3(0, 0, 1));
	r1.x = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = asint(asfloat(r1.x) * i.texcoord.w);
	r1.x = asint(1 / asfloat(r1.x));
	r1.xyz = asint(-(i.texcoord.xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	r2.xyz = asfloat(r1.yzx) + -(i.texcoord1.yzx);
	r1.xyz = asint(-(asfloat(r1.xyz)) + i.texcoord1.xyz);
	r3.xyz = r2.xyz * float3(1, -1, 1);
	r1.w = (0 < r2.z) ? -1 : 0;
	r2.xy = (r1.ww != 0) ? float2(0, 1) : float2(1, 0);
	r3.w = -(abs(r3.z));
	r1.w = asint(dot(r3.xyw, r3.xyw));
	r1.w = asint(sqrt(asfloat(r1.w)));
	r2.z = abs(r3.z) + asfloat(r1.w);
	r2.z = 1 / r2.z;
	r2.zw = r2.zz * r3.xy;
	r2.zw = r2.zw * float2(0.5, -0.5) + float2(0.5, 0.5);
	r3 = gDeferredLightShadowMap0_tex.Sample(gDeferredLightShadowMap0, r2.zw);
	r2.x = dot(r3.xy, r2.xy);
	r2.y = sqrt(i.texcoord1.w);
	r1.w = asint(asfloat(r1.w) * r2.y);
	r1.w = asint(min(asfloat(r1.w), 1));
	r1.w = (r2.x >= asfloat(r1.w)) ? -1 : 0;
	r1.w = r1.w & 1065353216;
	r2.x = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r2.y = r2.x + 0.00000999999975;
	r2.x = saturate(-(r2.x) * i.texcoord1.w + 1);
	r2.x = r2.x * r2.x;
	r2.x = r2.x * r2.x + -0.100000001;
	r2.x = max(r2.x, 0);
	r2.x = r2.x * 1.11111116;
	r2.y = rsqrt(r2.y);
	r1.xyz = asint(asfloat(r1.xyz) * r2.yyy);
	r3 = gbufferTexture1.Load(r0.xyz);
	r2.yzw = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
	r0.z = asint(dot(r2.yzw, r2.yzw));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r2.yzw = asfloat(r0.zzz) * r2.yzw;
	r0.z = asint(saturate(dot(asfloat(r1.xyz), r2.yzw)));
	r3.xyz = asfloat(r0.zzz) * i.texcoord2.xyz;
	r0.z = asint(dot(asfloat(r1.xyz), i.texcoord3.xyz));
	r0.z = asint(saturate(-(asfloat(r0.z)) * i.texcoord2.w + i.texcoord3.w));
	r3.xyz = asfloat(r0.zzz) * r3.xyz;
	r3.xyz = r2.xxx * r3.xyz;
	r3.xyz = asfloat(r1.www) * r3.xyz;
	r4 = i.texcoord.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.z = asint(dot(r4.xyz, r4.xyz));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r4 = asfloat(r0.zzz) * r4.xyz;
	r0.z = asint(dot(r4.xyz, r2.yzw));
	r0.z = asint(asfloat(r0.z) + asfloat(r0.z));
	r2.xyz = r2.yzw * -(asfloat(r0.zzz)) + r4.xyz;
	r0.z = asint(saturate(dot(asfloat(r1.xyz), r2.xyz)));
	r0.z = asint(asfloat(r0.z) + 0.00000999999975);
	r0.z = asint(log2(asfloat(r0.z)));
	r1 = asint(gbufferTexture2.Load(r0.xyw));
	r2 = gbufferTexture0.Load(r0.xyw);
	r0.xyw = asint(r2.xyz * r2.xyz);
	r1.y = asint(asfloat(r1.y) * asfloat(r1.y));
	r1.y = asint(asfloat(r1.y) * asfloat(r1.y));
	r1.y = asint(asfloat(r1.y) * 49 + 0.00000999999975);
	r0.z = asint(asfloat(r0.z) * asfloat(r1.y));
	r0.z = asint(exp2(asfloat(r0.z)));
	r1.yzw = asint(asfloat(r0.zzz) * r3.xyz);
	r1.xyz = asint(asfloat(r1.yzw) * asfloat(r1.xxx));
	o.xyz = asfloat(r0.xyw) * r3.xyz + asfloat(r1.xyz);
	o.w = 1;

	return o;
}
