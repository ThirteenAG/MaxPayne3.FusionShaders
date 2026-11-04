cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
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
	float4 globalDayNightEffects : packoffset(c9);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
	float4 ColorCorrectBottomOffset : packoffset(c11);
	float4 ColorShift : packoffset(c12);
	float4 deSatContrastGamma : packoffset(c13);
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
};

cbuffer Movement : register(b4)
{
	float4 umGlobalParams : packoffset(c0);
	float4 WindGlobalParams : packoffset(c1);
};

cbuffer PlantAttributes : register(b7)
{
	float g_fCollisionSqScale : packoffset(c0);
	float g_fGrassSpringRigidity : packoffset(c0.y);
	float g_fGrassSpringScale : packoffset(c0.z);
	float g_fEnableSpringForces : packoffset(c0.w);
	float4 g_vCollisionSpheres[5] : packoffset(c1);
	float3 g_vPlayerPosition : packoffset(c6);
	float2 g_vCollisionParams : packoffset(c7);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float3 normal : NORMAL;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float2 texcoord : TEXCOORD;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float3 r4;
	r0 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r0 = (int4)asfloat(r0);
	r0 = r0 * int4(3, 3, 3, 3);
	r1.x = asint(i.blendweight.x * gBoneMtx[r0.x / 3][0].w);
	r1.y = asint(i.blendweight.x * gBoneMtx[r0.x / 3][1].w);
	r1.z = asint(i.blendweight.x * gBoneMtx[r0.x / 3][2].w);
	r2.x = asint(i.blendweight.y * gBoneMtx[r0.y / 3][0].w);
	r2.y = asint(i.blendweight.y * gBoneMtx[r0.y / 3][1].w);
	r2.z = asint(i.blendweight.y * gBoneMtx[r0.y / 3][2].w);
	r1.xyz = asint(asfloat(r1.xyz) + asfloat(r2.xyz));
	r2.x = asint(i.blendweight.z * gBoneMtx[r0.z / 3][0].w);
	r2.y = asint(i.blendweight.z * gBoneMtx[r0.z / 3][1].w);
	r2.z = asint(i.blendweight.z * gBoneMtx[r0.z / 3][2].w);
	r0.xyz = asint(asfloat(r1.xyz) + asfloat(r2.xyz));
	r1.x = asint(i.blendweight.w * gBoneMtx[r0.w / 3][0].w);
	r1.y = asint(i.blendweight.w * gBoneMtx[r0.w / 3][1].w);
	r1.z = asint(i.blendweight.w * gBoneMtx[r0.w / 3][2].w);
	r0.xyz = asint(asfloat(r0.xyz) + asfloat(r1.xyz));
	r0.w = asint(i.color1.x * globalUmScalars.x);
	r1.xy = asint(asfloat(r0.ww) * umGlobalParams.xx);
	r0.w = asint(-(i.color1.z) + 1);
	r1.w = asint(asfloat(r0.w) * globalUmScalars.y);
	r1.z = asint(asfloat(r1.w) * umGlobalParams.y);
	r1.w = asint(i.color1.y * 6.28318548);
	r2.xyz = asint(globalUmScalars.zzw * umGlobalParams.zzw);
	r2.xyz = asint(globalScalars2.yyy * asfloat(r2.xyz) + asfloat(r1.www));
	r2.xyz = asint(sin(asfloat(r2.xyz)));
	r1.xyz = asint(asfloat(r2.xyz) * asfloat(r1.xyz) + i.position.xyz);
	r1.w = asint(asfloat(r1.z) * deSatContrastGamma.w);
	r0.w = asint(asfloat(r0.w) * WindGlobalParams.x);
	r1.xy = asint(asfloat(r1.ww) * asfloat(r0.ww) + asfloat(r1.xy));
	r2.xyz = asint(-(gWorld[3].xyz) + g_vPlayerPosition.xyz);
	r3.x = dot(gWorld[0].xyz, asfloat(r2.xyz));
	r3.y = dot(gWorld[1].xyz, asfloat(r2.xyz));
	r3.z = dot(gWorld[2].xyz, asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r0.xyz) + -(r3.xyz));
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(-(asfloat(r0.w)) + g_vCollisionParams.x);
	r0.w = asint(max(asfloat(r0.w), 0));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r2.xy = asint(asfloat(r1.ww) * asfloat(r2.xy));
	r2.xy = asint(asfloat(r2.xy) * i.color1.xx);
	r2.xy = asint(asfloat(r0.ww) * asfloat(r2.xy));
	r1.xy = asint(asfloat(r2.xy) * g_fCollisionSqScale + asfloat(r1.xy));
	r0.w = (0 < g_fEnableSpringForces) ? -1 : 0;
	if (r0.w != 0) {
		r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
		r0.w = asint(asfloat(r0.w) * 10);
		r0.w = asint(globalScalars2.y * g_fGrassSpringRigidity + asfloat(r0.w));
		r0.w = asint(sin(asfloat(r0.w)));
		r0.w = asint(asfloat(r0.w) * g_fGrassSpringScale);
		r2.xy = int2(0, 0);
		r1.w = 0;
		while (true) {
			r2.z = (r1.w >= 5) ? -1 : 0;
			if (r2.z != 0) break;
			r3.xyz = -(gWorld[3].xyz) + g_vCollisionSpheres[r1.w].xyz;
			r4.x = dot(gWorld[0].xyz, r3.xyz);
			r4.y = dot(gWorld[1].xyz, r3.xyz);
			r4.z = dot(gWorld[2].xyz, r3.xyz);
			r3.xyz = asfloat(r0.xyz) + -(r4.xyz);
			r2.z = asint(dot(r3.xyz, r3.xyz));
			r2.z = asint(sqrt(asfloat(r2.z)));
			r2.z = asint(-(asfloat(r2.z)) + g_vCollisionSpheres[r1.w].x);
			r2.z = asint(max(asfloat(r2.z), 0));
			r2.z = asint(asfloat(r0.w) * asfloat(r2.z));
			r3.xyz = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
			r2.w = asint(dot(r3.xyz, r3.xyz));
			r2.w = asint(rsqrt(asfloat(r2.w)));
			r3.xy = asfloat(r2.ww) * r3.xy;
			r3.xy = r3.xy * i.color1.xx;
			r2.zw = asint(asfloat(r2.zz) * r3.xy);
			r2.xy = asint(asfloat(r2.zw) * g_fCollisionSqScale + asfloat(r2.xy));
			r1.w = r1.w + 1;
		}
		r1.xy = asint(asfloat(r1.xy) + asfloat(r2.xy));
	}
	r0.xyz = asint(i.normal.yyy * gWorld[1].xyz);
	r0.xyz = asint(i.normal.xxx * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(i.normal.zzz * gWorld[2].xyz + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r2.xyz = asint(i.tangent.yyy * gWorld[1].xyz);
	r2.xyz = asint(i.tangent.xxx * gWorld[0].xyz + asfloat(r2.xyz));
	r2.xyz = asint(i.tangent.zzz * gWorld[2].xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.xyz = asint(asfloat(r0.www) * asfloat(r2.xyz));
	r3.xyz = asfloat(r0.yzx) * asfloat(r2.zxy);
	r3.xyz = asfloat(r2.yzx) * asfloat(r0.zxy) + -(r3.xyz);
	o.texcoord5 = r3.xyz * i.tangent.www;
	r3 = asfloat(r1.y) * gWorldViewProj[1];
	r3 = asfloat(r1.x) * gWorldViewProj[0] + r3;
	r1 = asint(asfloat(r1.z) * gWorldViewProj[2] + r3);
	r1 = asint(asfloat(r1) + gWorldViewProj[3]);
	r3 = i.position.y * gWorld[1];
	r3 = i.position.x * gWorld[0] + r3;
	r3 = i.position.z * gWorld[2] + r3;
	o.texcoord6 = r3 + gWorld[3];
	o.sv_position = asfloat(r1);
	o.color = i.color;
	o.texcoord1.w = asfloat(r1.w);
	o.texcoord1.xyz = asfloat(r0.xyz);
	o.texcoord4 = asfloat(r2.xyz);
	o.texcoord = i.texcoord.xy;

	return o;
}
