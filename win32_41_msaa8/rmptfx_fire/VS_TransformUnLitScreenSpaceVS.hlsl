cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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
	float4 globalScreenSize : packoffset(c8);
};

cbuffer CacheHybrid : register(b1)
{
	float HybridAdd : packoffset(c0);
};

cbuffer ParticleFire : register(b4)
{
	float gBiasToCamera : packoffset(c0);
	float gWrapScale : packoffset(c0.y);
	float gWrapBias : packoffset(c0.z);
	float gDiffuse : packoffset(c0.w);
	float gExtraLights : packoffset(c1);
	float gAmbientAmount : packoffset(c1.y);
	float gSuperAlpha : packoffset(c1.z);
	float gNormalArc : packoffset(c1.w);
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
	float3 r1;
	float3 r2;
	float r3;
	r0.y = asint(globalScreenSize.x / globalScreenSize.y);
	r1.z = 0;
	r0.xz = int2(1065353216, 1065353216);
	r2.x = sin(i.normal.z);
	r3 = cos(i.normal.z);
	r2.xy = r2.xx * i.normal.yx;
	r1.x = i.normal.x * r3.x + -(r2.x);
	r1.y = i.normal.y * r3.x + r2.y;
	r2.xy = i.position.xy;
	r2.z = 0;
	r0.xyz = asint(r1.xyz * asfloat(r0.xyz) + r2.xyz);
	r0.w = (i.normal.w == 1) ? -1 : 0;
	o.sv_position.xyz = (r0.www != 0) ? asfloat(r0.xyz) : r2.xyz;
	o.sv_position.w = 1;
	r0.x = asint(i.texcoord3.y * globalScalars4.x);
	o.texcoord.xyz = asfloat(r0.xxx) * i.color.xyz;
	o.texcoord.w = saturate(i.color.w * gSuperAlpha);
	r0 = asint(i.position.y * gWorldView[1]);
	r0 = asint(i.position.x * gWorldView[0] + asfloat(r0));
	r0 = asint(i.position.z * gWorldView[2] + asfloat(r0));
	o.texcoord7 = asfloat(r0) + gWorldView[3];
	o.texcoord1 = i.texcoord;
	r0.x = asint(-(i.texcoord3.x) + 1);
	r0.y = (0.5 < HybridAdd) ? -1 : 0;
	o.texcoord3.z = (r0.y != 0) ? asfloat(r0.x) : 1;
	o.texcoord3.x = i.texcoord2.z;
	o.texcoord3.y = 0;
	o.texcoord3.w = i.texcoord3.y;
	r0.xyz = asint(i.position.xyz + -(gViewInverse[3].xyz));
	r0.w = asint(asfloat(r0.z) * globalFogParams.x);
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * globalFogParams.z);
	r0.y = asint(asfloat(r0.w) * -1.44269502);
	r0.y = asint(exp2(asfloat(r0.y)));
	r0.y = asint(-(asfloat(r0.y)) + 1);
	r0.y = asint(asfloat(r0.y) / asfloat(r0.w));
	r0.z = (0.0000999999975 < abs(asfloat(r0.w))) ? -1 : 0;
	r0.y = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.x = (r0.z != 0) ? r0.y : r0.x;
	r0.x = asint(asfloat(r0.x) * -(globalFogParams.y));
	r0.x = asint(asfloat(r0.x) * 1.44269502);
	r0.x = asint(exp2(asfloat(r0.x)));
	o.texcoord4.w = -(asfloat(r0.x)) + 1;
	o.texcoord4.xyz = globalFogColorN.xyz;

	return o;
}
