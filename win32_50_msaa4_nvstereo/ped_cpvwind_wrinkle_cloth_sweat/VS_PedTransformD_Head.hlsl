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
	float4 gToneMapScalers : packoffset(c17);
	float4 gAmbientOcclusionEffect : packoffset(c18);
};

cbuffer CachePedParam : register(b4)
{
	float ArmourStrength : packoffset(c0);
	float reflectivePower : packoffset(c0.y);
	float3 specMapReflectMask : packoffset(c1);
	float fresnelRolloff : packoffset(c1.w);
	float bumpiness : packoffset(c2);
	float displacementScale : packoffset(c2.y);
	float specularFactor : packoffset(c2.z);
	float3 specMapIntMask : packoffset(c3);
	float4 specMapExpMask : packoffset(c4);
	float4 matMaterialColorScale : packoffset(c5);
	float4 gBloodData : packoffset(c6);
};

cbuffer BloodHitData : register(b7)
{
	float4 gBloodHeadHits[4] : packoffset(c0);
	float4 gBloodHeadCentreMass : packoffset(c4);
};

cbuffer PedWind : register(b9)
{
	float4 gWindParams : packoffset(c0);
	float4 AirResist : packoffset(c1);
	float WindStr : packoffset(c2);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 tangent : TANGENT;
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
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	int4 r3;
	r0.xyz = -(i.position.xyz) + gBloodHeadHits[0].xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = sqrt(r0.x);
	r0.x = -(r0.x) + 0.0500000007;
	r0.x = r0.x * 0.239999995;
	r0.x = max(r0.x, 0);
	r0.yzw = -(i.position.xyz) + gBloodHeadHits[1].xyz;
	r0.y = dot(r0.yzw, r0.yzw);
	r0.y = sqrt(r0.y);
	r0.y = -(r0.y) + 0.0500000007;
	r0.y = r0.y * 0.239999995;
	r0.x = max(r0.y, r0.x);
	r0.yzw = -(i.position.xyz) + gBloodHeadHits[2].xyz;
	r0.y = dot(r0.yzw, r0.yzw);
	r0.y = sqrt(r0.y);
	r0.y = -(r0.y) + 0.0500000007;
	r0.y = r0.y * 0.239999995;
	r0.x = max(r0.y, r0.x);
	r0.yzw = -(i.position.xyz) + gBloodHeadHits[3].xyz;
	r0.y = dot(r0.yzw, r0.yzw);
	r0.y = sqrt(r0.y);
	r0.y = -(r0.y) + 0.0500000007;
	r0.y = r0.y * 0.239999995;
	r0.x = max(r0.y, r0.x);
	r0.yzw = -(i.position.xyz) + gBloodHeadCentreMass.xyz;
	r0.yzw = r0.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = dot(r0.yzw, r0.yzw);
	r1.x = rsqrt(r1.x);
	r0.yzw = r0.yzw * r1.xxx;
	r0.xyz = r0.xxx * r0.yzw;
	r0.xyz = r0.xyz * gBloodData.xxx + i.position.xyz;
	r1.xy = r0.xy * float2(6, 4);
	r1.zw = AirResist.ww * float2(4, 1.5) + float2(1, 1);
	r0.w = globalScalars3.y * r1.w + r1.x;
	r0.w = sin(r0.w);
	r1.x = saturate(WindStr);
	r0.w = abs(r0.w) * r1.x;
	r1.x = dot(r0.xzy, float3(10, 10, 10));
	r1.w = r1.w * globalScalars3.y;
	r2.xyz = r1.zzz * i.color1.xxz;
	r2.xyz = -(r2.xyz) * i.normal.xyz;
	r1.x = r1.w * gWindParams.z + r1.x;
	r1.y = r1.w * gWindParams.w + r1.y;
	r1.xy = sin(r1.xy);
	r0.w = r0.w * abs(r1.x);
	r0.w = abs(r1.y) * r0.w;
	r1.x = globalScalars3.z + 0.00000999999975;
	r1.y = globalScalars4.z + 0.00000999999975;
	r1.z = 0.00000999999975;
	r1.w = dot(r1.xyz, r1.xyz);
	r1.w = rsqrt(r1.w);
	r1.xyz = r1.www * r1.xyz;
	r1.x = dot(r1.xyz, i.normal.xyz);
	r1.x = max(r1.x, 0.25);
	r1.x = min(r1.x, 1);
	r1.yzw = i.normal.yyy * gWorld[1].xyz;
	r1.yzw = i.normal.xxx * gWorld[0].xyz + r1.yzw;
	r1.yzw = i.normal.zzz * gWorld[2].xyz + r1.yzw;
	r1.yzw = r1.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.w = dot(r1.yzw, r1.yzw);
	r2.w = rsqrt(r2.w);
	r1.yzw = r1.yzw * r2.www;
	r2.w = saturate(dot(AirResist.xzy, r1.yzw));
	r2.w = -(r2.w) + 1;
	r2.w = -(r2.w) * AirResist.w + 1;
	r3.x = (0.800000012 < r2.w) ? -1 : 0;
	r2.w = (r3.x != 0) ? 1 : r2.w;
	r2.xyz = r2.www * r2.xyz;
	r2.xyz = r1.xxx * r2.xyz;
	r2.xyz = r2.xyz * r0.www + r0.xyz;
	r3 = asint(r2.y * gWorldViewProj[1]);
	r3 = asint(r2.x * gWorldViewProj[0] + asfloat(r3));
	r2 = r2.z * gWorldViewProj[2] + asfloat(r3);
	r2 = r2 + gWorldViewProj[3];
	o.sv_position = r2;
	o.texcoord1.w = r2.w;
	o.texcoord = i.texcoord;
	o.texcoord1.xyz = r1.yzw;
	r0.w = i.color.x * globalScalars.z + -1;
	r0.w = gAmbientOcclusionEffect.y * r0.w + 1;
	r1.x = 1 / gAmbientOcclusionEffect.y;
	r0.w = r0.w * r1.x;
	o.texcoord2.x = min(r0.w, 1);
	o.texcoord2.y = i.color.y * globalScalars2.w;
	o.texcoord2.zw = i.color.zw;
	r2.xyz = r0.yyy * gWorld[1].xyz;
	r0.xyw = r0.xxx * gWorld[0].xyz + r2.xyz;
	r0.xyw = r0.zzz * gWorld[2].xyz + r0.xyw;
	o.texcoord4.w = r0.z;
	r0.xyz = r0.xyw + gWorld[3].xyz;
	r2.xyz = -(r0.xyz) + gViewInverse[3].xyz;
	o.texcoord7 = r0.xyz;
	o.texcoord3 = r2.xyz;
	r0.xyz = i.tangent.yyy * gWorld[1].xyz;
	r0.xyz = i.tangent.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.tangent.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	o.texcoord4.xyz = r0.xyz;
	r3.xyz = asint(r1.zwy * r0.zxy);
	r3.xyz = asint(r0.yzx * r1.wyz + -(asfloat(r3.xyz)));
	o.texcoord6.z = dot(r1.yzw, r2.xyz);
	o.texcoord6.x = dot(r0.xyz, r2.xyz);
	r0.xyz = asfloat(r3.xyz) * i.tangent.www;
	o.texcoord5.xyz = r0.xyz;
	o.texcoord6.y = dot(r0.xyz, r2.xyz);
	o.texcoord5.w = i.tangent.w;

	return o;
}
