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

SamplerState StereoParmsTex : register(s9);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	int4 r1;
	float3 r2;
	r0.xyz = i.texcoord3.xyz + -(gDeferredLightPosition.xyz);
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1 = asint(StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0));
	r1.xyz = asint(asfloat(r1.xyz) + gViewInverse[3].xyz);
	r2 = -(asfloat(r1.xyz)) + i.texcoord3.xyz;
	r1.xyz = asint(-(asfloat(r1.xyz)) + i.texcoord4.xyz);
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2 = r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r2.xyz, r2.xyz);
	r0.w = rsqrt(r0.w);
	r2 = r0.www * r2.xyz;
	r0.x = dot(r0.xyz, r2.xyz);
	r0.y = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r0.y = rsqrt(r0.y);
	r0.yzw = r0.yyy * asfloat(r1.xyz);
	r1.xyz = asint(i.texcoord3.xyz + -(i.texcoord4.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
	r0.y = dot(asfloat(r1.xyz), r0.yzw);
	r0.z = i.texcoord2.w * 1.20000005;
	r0.z = r0.z / i.texcoord1.w;
	r0.z = saturate(-(abs(r0.y)) + r0.z);
	r0.z = r0.z * 3 + 1;
	r0.x = r0.z * r0.x;
	r0.x = saturate(abs(r0.x) + -(i.texcoord4.w));
	r0.x = saturate(-(r0.x) + abs(r0.y));
	r0.x = r0.x * i.texcoord1.w;
	r0.x = r0.x * 0.850000024;
	r0.x = i.texcoord1.w * 0.150000006 + r0.x;
	r0.y = i.texcoord2.w / i.texcoord1.w;
	r0.z = saturate(-(r0.y) + 1);
	r0.y = r0.y + 0.5;
	r0.x = r0.z * r0.x;
	r1.xy = (int2)i.sv_position.xy;
	r1.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r1.xyz));
	r1.yzw = asint(float3(0, 0, 1));
	r0.z = -(asfloat(r1.x)) * gDeferredProjParams.z + gDeferredProjParams.w;
	r0.z = r0.z * i.texcoord.w;
	r0.z = saturate(-1 / r0.z);
	r0.z = r0.z + 0.00000999999975;
	r0.z = log2(r0.z);
	r1.xyz = asint(i.texcoord.xyz * i.texcoord1.zxy);
	r1.xyz = asint(i.texcoord.zxy * i.texcoord1.xyz + -(asfloat(r1.xyz)));
	r2 = asfloat(r1.xyz) * i.texcoord1.zxy;
	r1.xyz = asint(i.texcoord1.yzx * asfloat(r1.yzx) + -(r2.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r0.w = rsqrt(r0.w);
	r1.xyz = asint(r0.www * asfloat(r1.xyz));
	r0.w = dot(asfloat(r1.xyz), i.texcoord.xyz);
	r1.x = (r0.w < gDeferredLightRadiusProjShearParams.x) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r1.y = asint(gDeferredLightRadiusProjShearParams.x * gDeferredLightRadiusProjShearParams.x);
	r0.w = -(r0.w) * r0.w + asfloat(r1.y);
	r0.w = sqrt(abs(r0.w));
	r1.z = asint(r0.w * asfloat(r1.x) + 0.00000999999975);
	r0.w = asfloat(r1.x) * r0.w;
	r0.z = r0.z * asfloat(r1.z);
	r0.z = exp2(r0.z);
	r1.x = asint(r0.z * r0.z);
	r0.x = r0.x * asfloat(r1.x);
	r0.y = -(r0.z) + r0.y;
	r0.y = saturate(r0.y + 1);
	r0.y = r0.y * i.texcoord1.w;
	r0.x = r0.x / r0.y;
	r1.xzw = asint(i.texcoord1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.y = dot(asfloat(r1.xzw), asfloat(r1.xzw));
	r0.y = rsqrt(r0.y);
	r1.xzw = asint(r0.yyy * asfloat(r1.xzw));
	r0.y = dot(asfloat(r1.xzw), i.texcoord1.xyz);
	r1.x = asint(dot(asfloat(r1.xzw), i.texcoord.xyz));
	r0.y = r0.y * r0.z + asfloat(r1.x);
	r0.z = max(-(r0.w), asfloat(r1.x));
	r0.y = max(-(r0.w), r0.y);
	r0.yz = min(r0.ww, r0.yz);
	r0.y = -(r0.z) + r0.y;
	r0.y = r0.w * 0.25 + r0.y;
	r0.x = r0.x * r0.y;
	r0.x = r0.x * r0.x;
	r0.x = r0.x / asfloat(r1.y);
	o.xyz = r0.xxx * i.texcoord2.xyz;
	o.w = 0;

	return o;
}
