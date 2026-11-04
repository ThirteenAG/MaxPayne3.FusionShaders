cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_lighting : register(b2)
{
	float4 gLightPosDir[4] : packoffset(c0);
	float4 gLightDir[4] : packoffset(c4);
	float4 gLightColor[4] : packoffset(c8);
	float4 gLightType : packoffset(c12);
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	int4 r2;
	float3 r3;
	float3 r4;
	float3 r5;
	float3 r6;
	r0.xyz = asint(-(i.texcoord.xyz) + gLightPosDir[0].xyz);
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(sqrt(asfloat(r0.w)));
	r1.xyz = asint(asfloat(r0.xyz) / asfloat(r0.www));
	r0.w = (0 != asfloat(r0.w)) ? -1 : 0;
	r0.xyz = (r0.www != 0) ? r1.xyz : r0.xyz;
	r0.xyz = asint(asfloat(r0.xyz) + gLightPosDir[0].xyz);
	r1.xyz = asint(min(gLightType.xyz, float3(1, 1, 1)));
	r0.xyz = asint(asfloat(r1.xxx) * asfloat(r0.xyz) + -(gLightPosDir[0].xyz));
	r2.xyz = asint(-(i.texcoord.xyz) + gViewInverse[3].xyz);
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r3 = asfloat(r2.xyz) * asfloat(r0.www) + asfloat(r0.xyz);
	r1.x = asint(dot(r3.xyz, r3.xyz));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r3 = asfloat(r1.xxx) * r3.xyz;
	r1.x = asint(dot(i.texcoord2.xyz, i.texcoord2.xyz));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r4 = asfloat(r1.xxx) * i.texcoord2.xyz;
	r3.x = saturate(dot(r3.xyz, r4.xyz));
	r5 = -(i.texcoord.xyz) + gLightPosDir[1].xyz;
	r1.x = asint(dot(r5.xyz, r5.xyz));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r6 = r5.xyz / asfloat(r1.xxx);
	r1.x = (0 != asfloat(r1.x)) ? -1 : 0;
	r5 = (r1.xxx != 0) ? r6.xyz : r5.xyz;
	r5 = r5.xyz + gLightPosDir[1].xyz;
	r1.xyw = asint(asfloat(r1.yyy) * r5.xyz + -(gLightPosDir[1].xyz));
	r5 = asfloat(r2.xyz) * asfloat(r0.www) + asfloat(r1.xyw);
	r2.w = asint(dot(r5.xyz, r5.xyz));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r5 = asfloat(r2.www) * r5.xyz;
	r3.y = saturate(dot(r5.xyz, r4.xyz));
	r5 = -(i.texcoord.xyz) + gLightPosDir[2].xyz;
	r2.w = asint(dot(r5.xyz, r5.xyz));
	r2.w = asint(sqrt(asfloat(r2.w)));
	r6 = r5.xyz / asfloat(r2.www);
	r2.w = (0 != asfloat(r2.w)) ? -1 : 0;
	r5 = (r2.www != 0) ? r6.xyz : r5.xyz;
	r5 = r5.xyz + gLightPosDir[2].xyz;
	r5 = asfloat(r1.zzz) * r5.xyz + -(gLightPosDir[2].xyz);
	r2.xyz = asint(asfloat(r2.xyz) * asfloat(r0.www) + r5.xyz);
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asint(asfloat(r0.www) * asfloat(r2.xyz));
	r3.z = saturate(dot(asfloat(r2.xyz), r4.xyz));
	r2.xyz = asint(r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.xyz = asint(log2(asfloat(r2.xyz)));
	r2.xyz = asint(asfloat(r2.xyz) * float3(32.0000114, 32.0000114, 32.0000114));
	r2.xyz = asint(exp2(asfloat(r2.xyz)));
	r2.xyz = asint(min(asfloat(r2.xyz), float3(1, 1, 1)));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.x = asint(saturate(dot(asfloat(r0.xyz), r4.xyz)));
	r0.w = asint(dot(asfloat(r1.xyw), asfloat(r1.xyw)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.xyz = asint(asfloat(r0.www) * asfloat(r1.xyw));
	r0.y = asint(saturate(dot(asfloat(r1.xyz), r4.xyz)));
	r0.w = asint(dot(r5.xyz, r5.xyz));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r1.xyz = asint(asfloat(r0.www) * r5.xyz);
	r0.z = asint(saturate(dot(asfloat(r1.xyz), r4.xyz)));
	r0.xyz = asint(asfloat(r0.xyz) * float3(0.5, 0.5, 0.5) + asfloat(r2.xyz));
	r1.xyz = asint(asfloat(r0.yyy) * gLightColor[1].xyz);
	r0.xyw = asint(asfloat(r0.xxx) * gLightColor[0].xyz + asfloat(r1.xyz));
	r0.xyz = asint(asfloat(r0.zzz) * gLightColor[2].xyz + asfloat(r0.xyw));
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.300000012, 0.300000012, 0.300000012));
	o.xyz = asfloat(r0.xyz) * i.texcoord3.xyz;
	o.w = i.texcoord3.w;

	return o;
}
