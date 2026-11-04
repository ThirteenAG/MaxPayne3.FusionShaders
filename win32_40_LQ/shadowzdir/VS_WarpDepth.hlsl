cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
};

cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gShadowParam14151617 : packoffset(c1);
	float4 gShadowParam0123 : packoffset(c2);
	float4 gShadowParam4567 : packoffset(c3);
	float4 gShadowParam891113 : packoffset(c4);
	float4 gCascadeZScales : packoffset(c5);
	float4 gCascadeZOffsets : packoffset(c6);
	float4 gCascadeXThresholds : packoffset(c7);
	float4 gCascadeYThresholds : packoffset(c8);
	float4 gShadowParamPCF : packoffset(c9);
	row_major float4x4 gShadowMatrix : packoffset(c10);
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(float3 position : POSITION)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = (gShadowParam14151617.xy == float2(0, 0)) ? -1 : 0;
	r0.y = (r0.y != 0) ? 1056964608 : -1090519040;
	r1.xyz = position.yyy * gWorld[1].xyz;
	r1.xyz = position.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = position.zzz * gWorld[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + gWorld[3].xyz;
	r2.xyz = r1.yyy * gShadowMatrix[1].xyz;
	r2.xyz = r1.xxx * gShadowMatrix[0].xyz + r2.xyz;
	r2.xyz = r1.zzz * gShadowMatrix[2].xyz + r2.xyz;
	o.texcoord1.xyz = r1.xyz;
	r1.xyz = r2.xyz + gShadowMatrix[3].xyz;
	r0.z = asint(r1.z + gShadowParam891113.z);
	r1.w = dot(asfloat(r0.yy), asfloat(r0.zz));
	r0.y = asint(dot(r1.xyw, r1.xyw));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.z = asint(-(r1.w) + asfloat(r0.y));
	r2.z = asfloat(r0.y) * -(gShadowParam0123.w);
	r2.w = r1.w * -(gShadowParam0123.w);
	r2.xy = r1.xy / asfloat(r0.zz);
	r0.y = asint(gShadowParam0123.x * gShadowParam891113.w);
	r0.y = asint(r1.z * gShadowParam891113.w + asfloat(r0.y));
	r0.z = asint(gShadowParam0123.x + -(gShadowParam891113.w));
	r3.z = asfloat(r0.y) / asfloat(r0.z);
	r3.xy = r1.xy * gShadowParam0123.zz;
	r3.w = -(r1.z);
	r0 = asint((r0.x != 0) ? r2 : r3);
	o.sv_position = asfloat(r0);
	o.texcoord1.w = asfloat(r0.w);

	return o;
}
