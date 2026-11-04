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
	float4 gDeferredLightShaftParams : packoffset(c9);
	float4 gDeferredLightVolumeParams : packoffset(c10);
};

SamplerState StereoParmsTex : register(s9);
Texture2D StereoParmsTex_tex : register(t9);

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	int4 r0;
	float3 r1;
	float4 r2;
	r0.x = asint(saturate(-(position.z)));
	r0.x = asint(-(asfloat(r0.x)) + 1);
	r0.x = asint(asfloat(r0.x) * gDeferredLightConeAngle);
	r0.x = asint(cos(asfloat(r0.x)));
	r0.y = asint(-(asfloat(r0.x)) * asfloat(r0.x) + 1);
	r0.z = asint(dot(position.xy, position.xy));
	r0.y = asint(asfloat(r0.y) / asfloat(r0.z));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.y = asint(asfloat(r0.y) * gDeferredVolumeRadiusScale);
	r0.yz = asint(asfloat(r0.yy) * position.xy);
	r1 = gDeferredLightDirection.yzx * gDeferredLightTangent.zxy;
	r1 = gDeferredLightTangent.yzx * gDeferredLightDirection.zxy + -(r1.xyz);
	r1 = asfloat(r0.zzz) * r1.xyz;
	r0.yzw = asint(gDeferredLightTangent.xyz * asfloat(r0.yyy) + r1.xyz);
	r0.xyz = asint(gDeferredLightDirection.xyz * asfloat(r0.xxx) + asfloat(r0.yzw));
	r0.w = asint(abs(position.y) + abs(position.x));
	r0.w = (asfloat(r0.w) >= 0.990000010) ? -1 : 0;
	r0.xyz = r0.xyz & r0.www;
	r0.w = asint(gDeferredLightRadiusProjShearParams.x * gDeferredVolumeRadiusScale);
	r0.w = asint(asfloat(r0.w) * 0.662000000);
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	o.texcoord1.w = asfloat(r0.w);
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r0.w = asint(100 / asfloat(r0.w));
	r0.w = asint(min(asfloat(r0.w), 1));
	r1 = asfloat(r0.xyz) * asfloat(r0.www) + gDeferredLightPosition.xyz;
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) + 0.00000999999975);
	r2 = r1.y * gWorldViewProj[1];
	r2 = r1.x * gWorldViewProj[0] + r2;
	r2 = r1.z * gWorldViewProj[2] + r2;
	r2 = r2 + gWorldViewProj[3];
	o.sv_position = r2;
	o.texcoord.w = r2.w;
	r2 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0);
	r0.yzw = asint(r2.xyz + gViewInverse[3].xyz);
	r2.xyz = asfloat(r0.yzw) + -(gDeferredLightPosition.xyz);
	o.texcoord1.xyz = -(asfloat(r0.yzw)) + r1.xyz;
	o.texcoord3 = r1.xyz;
	o.texcoord.xyz = r2.xyz;
	r0.yzw = asint(r2.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	o.texcoord2.w = asfloat(r0.x);
	o.texcoord4.xyz = gDeferredLightDirection.xyz * asfloat(r0.xxx) + gDeferredLightPosition.xyz;
	r0.x = asint(gDeferredLightColourAndIntensity.w * gDeferredLightVolumeParams.x);
	r0.x = asint(asfloat(r0.x) * 0.25);
	o.texcoord2.xyz = asfloat(r0.xxx) * gDeferredLightColourAndIntensity.xyz;
	r0.x = asint(dot(asfloat(r0.yzw), asfloat(r0.yzw)));
	r0.x = asint(rsqrt(asfloat(r0.x)));
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r0.yzw));
	r0.x = asint(dot(gDeferredLightDirection.xyz, asfloat(r0.xyz)));
	r0.x = asint(abs(asfloat(r0.x)) + 0.00000999999975);
	r0.x = asint(log2(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * 2.50001001);
	o.texcoord4.w = exp2(asfloat(r0.x));
	o.texcoord5 = float4(0, 0, 0, 0);

	return o;
}
