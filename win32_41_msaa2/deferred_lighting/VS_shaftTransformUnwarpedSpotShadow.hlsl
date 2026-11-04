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
	int4 r1;
	float4 r2;
	float4 r3;
	r0.xyz = asint(gDeferredLightDirection.yzx * gDeferredLightTangent.zxy);
	r0.xyz = asint(gDeferredLightTangent.yzx * gDeferredLightDirection.zxy + -(asfloat(r0.xyz)));
	r0.w = asint(saturate(-(position.z)));
	r0.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(asfloat(r0.w) * gDeferredLightConeAngle);
	r0.w = asint(cos(asfloat(r0.w)));
	r1.x = asint(-(asfloat(r0.w)) * asfloat(r0.w) + 1);
	r1.y = asint(dot(position.xy, position.xy));
	r1.x = asint(asfloat(r1.x) / asfloat(r1.y));
	r1.y = (asfloat(r1.y) >= 0.0000999999975) ? -1 : 0;
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.z = asint(min(gDeferredVolumeRadiusScale, 0.980000019));
	r1.x = asint(asfloat(r1.z) * asfloat(r1.x));
	r1.z = asint(asfloat(r1.z) * gDeferredLightRadiusProjShearParams.x);
	r2.w = asfloat(r1.z) * 0.662000000;
	r1.xz = asint(asfloat(r1.xx) * position.xy);
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.zzz));
	r0.xyz = asint(gDeferredLightTangent.xyz * asfloat(r1.xxx) + asfloat(r0.xyz));
	r0.xyz = asint(gDeferredLightDirection.xyz * asfloat(r0.www) + asfloat(r0.xyz));
	r0.w = (abs(position.z) >= 0.0000999999975) ? -1 : 0;
	r0.w = r0.w & 1065353216;
	r1.xzw = asint(asfloat(r0.www) * gDeferredLightDirection.xyz);
	r0.xyz = (r1.yyy != 0) ? r0.xyz : r1.xzw;
	r1.xyz = asint(asfloat(r0.xyz) * r2.www + gDeferredLightPosition.xyz);
	r0.xyz = asint(r2.www * asfloat(r0.xyz));
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) + 0.00000999999975);
	r3 = asfloat(r1.y) * gWorldViewProj[1];
	r3 = asfloat(r1.x) * gWorldViewProj[0] + r3;
	r3 = asfloat(r1.z) * gWorldViewProj[2] + r3;
	r3 = r3 + gWorldViewProj[3];
	o.sv_position = r3;
	r3.xyz = gViewInverse[3].xyz + -(gDeferredLightPosition.xyz);
	o.texcoord = r3;
	o.texcoord5.w = r3.w;
	r0.yzw = asint(r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.xyz = asfloat(r1.xyz) + -(gViewInverse[3].xyz);
	o.texcoord3 = asfloat(r1.xyz);
	o.texcoord1 = r2;
	o.texcoord5.xyz = -(r2.xyz);
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

	return o;
}
