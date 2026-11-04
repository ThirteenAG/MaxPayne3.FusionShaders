cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_ptx : register(b3)
{
	float4 gForcedColor : packoffset(c0);
	float4 gAspectRatio : packoffset(c1);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
};

cbuffer rage_SoftParticleBuffer : register(b1)
{
	float4 NearFarPlane : packoffset(c0);
};

cbuffer CacheHybrid : register(b4)
{
	float HybridAdd : packoffset(c0);
};

cbuffer ParticleSmoke : register(b7)
{
	float gBiasToCamera : packoffset(c0);
	float gWrapScale : packoffset(c0.y);
	float gWrapBias : packoffset(c0.z);
	float gDiffuse : packoffset(c0.w);
	float gExtraLights : packoffset(c1);
	float gAmbientAmount : packoffset(c1.y);
	float gSuperAlpha : packoffset(c1.z);
	float gNormalArc : packoffset(c1.w);
	float gScaleFade : packoffset(c2);
	float gUseShadows : packoffset(c2.y);
	float gAmbientShadow : packoffset(c2.z);
	float gLightIntensityClamp : packoffset(c2.w);
	float4 gTexCoordScaleOffset0 : packoffset(c3);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	float3 r2;
	float4 r3;
	float r4;
	r0.zw = int2(0, 0);
	r1.x = (0.000000999999997 >= i.color.w) ? -1 : 0;
	r1.y = asint(1 / gScaleFade);
	r2 = -(i.position.xyz) + gViewInverse[3].xyz;
	r1.z = asint(gBiasToCamera * 0.100000001);
	r2 = r2.xyz * asfloat(r1.zzz) + i.position.xyz;
	r3 = r2.y * gWorldViewProj[1];
	r3 = r2.x * gWorldViewProj[0] + r3;
	r3 = r2.z * gWorldViewProj[2] + r3;
	r3 = r3 + gWorldViewProj[3];
	r1.z = asint(r3.w + -(NearFarPlane.x));
	r1.y = asint(saturate(asfloat(r1.y) * asfloat(r1.z)));
	r1.x = (r1.x != 0) ? 0 : r1.y;
	r1.yz = asint(asfloat(r1.xx) * i.normal.yx);
	r1.x = asint(asfloat(r1.x) * i.color.w);
	o.texcoord.w = saturate(asfloat(r1.x) * gSuperAlpha);
	r1.x = asint(sin(i.normal.z));
	r4 = cos(i.normal.z);
	r1.xw = asint(asfloat(r1.xx) * asfloat(r1.yz));
	r0.x = asint(asfloat(r1.z) * r4.x + -(asfloat(r1.x)));
	r0.y = asint(asfloat(r1.y) * r4.x + asfloat(r1.w));
	o.sv_position = asfloat(r0) * gAspectRatio + r3;
	o.texcoord3.y = r3.w;
	r0.x = asint(i.texcoord3.y * globalScalars4.x);
	o.texcoord.xyz = asfloat(r0.xxx) * i.color.xyz;
	r0 = asint(r2.y * gWorldView[1]);
	r0 = asint(r2.x * gWorldView[0] + asfloat(r0));
	r0 = asint(r2.z * gWorldView[2] + asfloat(r0));
	r1.xyz = asint(r2.xyz + -(gViewInverse[3].xyz));
	o.texcoord7 = asfloat(r0) + gWorldView[3];
	o.texcoord1 = i.texcoord * gTexCoordScaleOffset0.xyxy + gTexCoordScaleOffset0.zwzw;
	r0.x = asint(-(i.texcoord3.x) + 1);
	r0.y = (0.5 < HybridAdd) ? -1 : 0;
	o.texcoord3.z = (r0.y != 0) ? asfloat(r0.x) : 1;
	o.texcoord3.x = i.texcoord2.z;
	o.texcoord3.w = i.texcoord3.y;
	r0.x = asint(asfloat(r1.z) * globalFogParams.x);
	r0.y = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.y = asint(asfloat(r0.y) * globalFogParams.z);
	r0.z = asint(asfloat(r0.x) * -1.44269502);
	r0.z = asint(exp2(asfloat(r0.z)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(asfloat(r0.z) / asfloat(r0.x));
	r0.x = (0.0000999999975 < abs(asfloat(r0.x))) ? -1 : 0;
	r0.z = asint(asfloat(r0.z) * asfloat(r0.y));
	r0.x = (r0.x != 0) ? r0.z : r0.y;
	r0.x = asint(asfloat(r0.x) * -(globalFogParams.y));
	r0.x = asint(asfloat(r0.x) * 1.44269502);
	r0.x = asint(exp2(asfloat(r0.x)));
	o.texcoord4.w = -(asfloat(r0.x)) + 1;
	o.texcoord4.xyz = globalFogColorN.xyz;

	return o;
}
