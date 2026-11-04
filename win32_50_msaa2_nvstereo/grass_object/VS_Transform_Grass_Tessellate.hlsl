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
	float4 globalDayNightEffects : packoffset(c9);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
	float4 ColorCorrectBottomOffset : packoffset(c11);
	float4 ColorShift : packoffset(c12);
	float4 deSatContrastGamma : packoffset(c13);
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
};

cbuffer CacheMegaVariables : register(b4)
{
	float specularFactor : packoffset(c0);
	float specularColorFactor : packoffset(c0.y);
};

cbuffer Movement : register(b7)
{
	float4 umGlobalParams : packoffset(c0);
	float4 WindGlobalParams : packoffset(c1);
};

cbuffer PlantAttributes : register(b9)
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
	float3 normal : NORMAL;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 texcoord8 : TEXCOORD8;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	int4 r2;
	float3 r3;
	float3 r4;
	r0.x = asint(i.color1.x * globalUmScalars.x);
	r0.xy = asint(asfloat(r0.xx) * umGlobalParams.xx);
	r0.w = asint(-(i.color1.z) + 1);
	r1.x = asfloat(r0.w) * globalUmScalars.y;
	r0.z = asint(r1.x * umGlobalParams.y);
	r1.x = i.color1.y * 6.28318548;
	r1.yzw = globalUmScalars.zzw * umGlobalParams.zzw;
	r1.xyz = globalScalars2.yyy * r1.yzw + r1.xxx;
	r1.xyz = sin(r1.xyz);
	r1.xyz = r1.xyz * asfloat(r0.xyz) + i.position.xyz;
	r0.x = asint(r1.z * deSatContrastGamma.w);
	r0.y = asint(asfloat(r0.w) * WindGlobalParams.x);
	r1.xy = asfloat(r0.xx) * asfloat(r0.yy) + r1.xy;
	r0.xyz = asint(-(gWorld[3].xyz) + g_vPlayerPosition.xyz);
	r2.x = asint(dot(gWorld[0].xyz, asfloat(r0.xyz)));
	r2.y = asint(dot(gWorld[1].xyz, asfloat(r0.xyz)));
	r2.z = asint(dot(gWorld[2].xyz, asfloat(r0.xyz)));
	r0.xyz = asint(r1.xyz + -(asfloat(r2.xyz)));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(-(asfloat(r0.w)) + g_vCollisionParams.x);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.z = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.z = asint(rsqrt(asfloat(r0.z)));
	r0.xy = asint(asfloat(r0.zz) * asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.xy) * i.color1.xx);
	r0.xy = asint(asfloat(r0.ww) * asfloat(r0.xy));
	r0.xy = asint(asfloat(r0.xy) * g_fCollisionSqScale + r1.xy);
	r0.w = (0 < g_fEnableSpringForces) ? -1 : 0;
	if (r0.w != 0) {
		r0.w = asint(dot(r1.xyz, r1.xyz));
		r0.w = asint(asfloat(r0.w) * 10);
		r0.w = asint(globalScalars2.y * g_fGrassSpringRigidity + asfloat(r0.w));
		r0.w = asint(sin(asfloat(r0.w)));
		r0.w = asint(asfloat(r0.w) * g_fGrassSpringScale);
		r0.z = asint(r1.z);
		r2.xyz = int3(0, 0, 0);
		while (true) {
			r2.w = (r2.z >= 5) ? -1 : 0;
			if (r2.w != 0) break;
			r3 = -(gWorld[3].xyz) + g_vCollisionSpheres[r2.z].xyz;
			r4.x = dot(gWorld[0].xyz, r3.xyz);
			r4.y = dot(gWorld[1].xyz, r3.xyz);
			r4.z = dot(gWorld[2].xyz, r3.xyz);
			r3 = asfloat(r0.xyz) + -(r4.xyz);
			r2.w = asint(dot(r3.xyz, r3.xyz));
			r2.w = asint(sqrt(asfloat(r2.w)));
			r2.w = asint(-(asfloat(r2.w)) + g_vCollisionSpheres[r2.z].x);
			r2.w = asint(max(asfloat(r2.w), 0));
			r2.w = asint(asfloat(r0.w) * asfloat(r2.w));
			r3 = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
			r3.z = dot(r3.xyz, r3.xyz);
			r3.z = rsqrt(r3.z);
			r3.xy = r3.zz * r3.xy;
			r3.xy = r3.xy * i.color1.xx;
			r3.xy = asfloat(r2.ww) * r3.xy;
			r2.xy = asint(r3.xy * g_fCollisionSqScale + asfloat(r2.xy));
			r2.z = r2.z + 1;
		}
		r1.xy = asfloat(r0.xy) + asfloat(r2.xy);
	} else {
		r1.xy = asfloat(r0.xy);
	}
	r0.xyz = asint(i.normal.yyy * gWorld[1].xyz);
	r0.xyz = asint(i.normal.xxx * gWorld[0].xyz + asfloat(r0.xyz));
	r0.xyz = asint(i.normal.zzz * gWorld[2].xyz + asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r0.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r2.xyz = asint(i.position.yyy * gWorld[1].xyz);
	r2.xyz = asint(i.position.xxx * gWorld[0].xyz + asfloat(r2.xyz));
	r2.xyz = asint(i.position.zzz * gWorld[2].xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) + gWorld[3].xyz);
	o.texcoord1 = asfloat(r0.xyz) * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
	r0.x = asint(max(specularFactor, 1));
	r0.x = asint(asfloat(r0.x) * 0.00510204071);
	r0.x = asint(min(asfloat(r0.x), 1));
	o.texcoord6.y = sqrt(asfloat(r0.x));
	r0.xyz = asint(asfloat(r2.xyz) + -(gViewInverse[3].xyz));
	r0.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r0.x = asint(sqrt(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) + -0.649999976);
	r0.x = asint(max(asfloat(r0.x), 0.25));
	r0.x = asint(min(asfloat(r0.x), 1));
	o.texcoord6.w = asfloat(r0.x) * globalScalars.x;
	r1.w = 1;
	o.texcoord8 = r1;
	o.texcoord6.x = specularColorFactor;
	o.texcoord6.z = i.color.x;
	o.texcoord7 = asfloat(r2.xyz);
	o.texcoord = i.texcoord.xy;

	return o;
}
