cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer vehicle_switchon : register(b13)
{
	bool switchOn : packoffset(c0);
};

cbuffer CacheVehicleRadius : register(b4)
{
	float BoundRadius : packoffset(c0);
};

cbuffer VehicleSnow : register(b9)
{
	float envEffThickness : packoffset(c0);
	float2 envEffScale : packoffset(c0.y);
};

SamplerState DamageSampler : register(s1);
Texture2D DamageSampler_tex : register(t1);

struct VS_IN
{
	float3 position : POSITION;
	float4 blendindices : BLENDINDICES;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float texcoord4 : TEXCOORD4;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	int4 r5;
	float3 r6;
	float4 r7;
	float3 r8;
	float3 r9;
	r0.x = asint(saturate(i.color.w));
	r0.y = asint(asfloat(r0.x) + -0.5);
	r0.y = asint(max(asfloat(r0.y), 0));
	r0.y = asint(asfloat(r0.y) + asfloat(r0.y));
	if (switchOn != 0) {
		r0.z = asint(dot(i.position.xyz, i.position.xyz));
		r0.z = asint(sqrt(asfloat(r0.z)));
		r1.xyz = asint(i.position.xyz / asfloat(r0.zzz));
		r0.w = asint(-(asfloat(r1.z)) + 1);
		r0.w = asint(asfloat(r0.w) * 0.5);
		r1.xy = asint(asfloat(r1.xy) + float2(0.00000999999975, 0.00000999999975));
		r1.z = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
		r1.z = asint(rsqrt(asfloat(r1.z)));
		r1.xy = asint(asfloat(r1.zz) * asfloat(r1.xy));
		r1.xy = asint(asfloat(r0.ww) * asfloat(r1.xy));
		r1.xy = asint(asfloat(r1.xy) * float2(0.5, 0.5) + float2(0.5, 0.5));
		r1.zw = asint(asfloat(r1.xy) * float2(126.732674, 126.732674));
		r2.xy = (asfloat(r1.zw) >= -(asfloat(r1.zw))) ? -1 : 0;
		r1.zw = asint(frac(abs(asfloat(r1.zw))));
		r1.zw = (r2.xy != 0) ? r1.zw : asint(-(asfloat(r1.zw)));
		r2 = asint(DamageSampler_tex.SampleLevel(DamageSampler, asfloat(r1.xy), 0));
		r1.xy = asint(-(asfloat(r1.zw)) * float2(0.00789062493, 0.00789062493) + asfloat(r1.xy));
		r3 = asfloat(r1.xyxy) + float4(0.00789062493, 0, 0, 0.00789062493);
		r4 = DamageSampler_tex.SampleLevel(DamageSampler, r3.xy, 0);
		r3 = DamageSampler_tex.SampleLevel(DamageSampler, r3.zw, 0);
		r2.yz = asint(asfloat(r1.xy) + float2(0.00789062493, 0.00789062493));
		r5 = asint(DamageSampler_tex.SampleLevel(DamageSampler, asfloat(r2.yz), 0));
		r0.w = asint(asfloat(r2.x) * 0.0000152587891);
		r6.z = trunc(asfloat(r0.w));
		r0.w = asint(-(r6.z) * 65536 + asfloat(r2.x));
		r2.x = asint(asfloat(r0.w) * 0.00390625);
		r6.y = trunc(asfloat(r2.x));
		r6.x = -(r6.y) * 256 + asfloat(r0.w);
		r0.w = asint(r4.x * 0.0000152587891);
		r2.z = asint(trunc(asfloat(r0.w)));
		r0.w = asint(-(asfloat(r2.z)) * 65536 + r4.x);
		r2.w = asint(asfloat(r0.w) * 0.00390625);
		r2.y = asint(trunc(asfloat(r2.w)));
		r2.x = asint(-(asfloat(r2.y)) * 256 + asfloat(r0.w));
		r0.w = asint(r3.x * 0.0000152587891);
		r4.z = trunc(asfloat(r0.w));
		r0.w = asint(-(r4.z) * 65536 + r3.x);
		r2.w = asint(asfloat(r0.w) * 0.00390625);
		r4.y = trunc(asfloat(r2.w));
		r4.x = -(r4.y) * 256 + asfloat(r0.w);
		r0.w = asint(asfloat(r5.x) * 0.0000152587891);
		r3.z = trunc(asfloat(r0.w));
		r0.w = asint(-(r3.z) * 65536 + asfloat(r5.x));
		r2.w = asint(asfloat(r0.w) * 0.00390625);
		r3.y = trunc(asfloat(r2.w));
		r3.x = -(r3.y) * 256 + asfloat(r0.w);
		r5.xy = asint(-(asfloat(r1.zw)) + float2(1, 1));
		r7.xyz = asfloat(r5.xxx) * r6.xyz;
		r8 = asfloat(r1.zzz) * asfloat(r2.xyz);
		r8 = asfloat(r5.yyy) * r8.xyz;
		r5.yzw = asint(r7.xyz * asfloat(r5.yyy) + r8.xyz);
		r7.xyz = r4.xyz * asfloat(r5.xxx);
		r5.xyz = asint(r7.xyz * asfloat(r1.www) + asfloat(r5.yzw));
		r3.xyz = asfloat(r1.zzz) * r3.xyz;
		r3.xyz = r3.xyz * asfloat(r1.www) + asfloat(r5.xyz);
		r3.xyz = r3.xyz + float3(-128, -128, -128);
		r3.xyz = r3.xyz * float3(0.0078125, 0.0078125, 0.0078125);
		r0.z = asint(asfloat(r0.z) / BoundRadius);
		r0.z = asint(min(asfloat(r0.z), 1));
		r3.xyz = asfloat(r0.zzz) * r3.xyz;
		r3.xyz = r3.xyz * float3(0.5, 0.5, 0.5) + i.position.xyz;
		r5.xyz = (i.normal.xyz == float3(1, 1, 1)) ? -1 : 0;
		r0.w = r5.y & r5.x;
		r0.w = r5.z & r0.w;
		if (r0.w != 0) {
			r5.xyz = int3(0, 0, 1065353216);
		} else {
			r7 = asfloat(r1.xyxy) + float4(-0.5, -0.5, -0.492109388, -0.5);
			r7 = r7 + r7;
			r0.w = asint(dot(r7.xy, r7.xy));
			r1.z = (0 < asfloat(r0.w)) ? -1 : 0;
			r0.w = asint(sqrt(asfloat(r0.w)));
			r0.w = r0.w & r1.z;
			r1.z = asint(-(asfloat(r0.w)) * 2 + 1);
			r8.z = max(asfloat(r1.z), -1);
			r1.z = (r8.z < 1) ? -1 : 0;
			r1.w = (-1 < r8.z) ? -1 : 0;
			r1.z = r1.w & r1.z;
			r1.w = (0 < asfloat(r0.w)) ? -1 : 0;
			r1.z = r1.w & r1.z;
			r1.w = asint(-(r8.z) * r8.z + 1);
			r1.w = asint(sqrt(asfloat(r1.w)));
			r0.w = asint(asfloat(r1.w) / asfloat(r0.w));
			r0.w = r0.w & r1.z;
			r8.xy = asfloat(r0.ww) * r7.xy;
			r6 = r6.xyz + float3(-128, -128, -128);
			r6 = asfloat(r0.zzz) * r6.xyz;
			r6 = r6.xyz * float3(0.00390625, 0.00390625, 0.00390625);
			r0.w = asint(dot(r7.zw, r7.zw));
			r1.z = (0 < asfloat(r0.w)) ? -1 : 0;
			r0.w = asint(sqrt(asfloat(r0.w)));
			r0.w = r0.w & r1.z;
			r1.z = asint(-(asfloat(r0.w)) * 2 + 1);
			r9.z = max(asfloat(r1.z), -1);
			r1.z = (r9.z < 1) ? -1 : 0;
			r1.w = (-1 < r9.z) ? -1 : 0;
			r1.z = r1.w & r1.z;
			r1.w = (0 < asfloat(r0.w)) ? -1 : 0;
			r1.z = r1.w & r1.z;
			r1.w = asint(-(r9.z) * r9.z + 1);
			r1.w = asint(sqrt(asfloat(r1.w)));
			r0.w = asint(asfloat(r1.w) / asfloat(r0.w));
			r0.w = r0.w & r1.z;
			r9.xy = asfloat(r0.ww) * r7.zw;
			r7.xyz = r9.xyz + float3(0.00000000999999994, 0.00000000999999994, 0.00000000999999994);
			r2.xyz = asint(asfloat(r2.xyz) + float3(-128, -128, -128));
			r2.xyz = asint(asfloat(r0.zzz) * asfloat(r2.xyz));
			r7.xyz = -(r8.xyz) + r7.xyz;
			r2.xyz = asint(asfloat(r2.xyz) * float3(0.00390625, 0.00390625, 0.00390625) + -(r6.xyz));
			r0.w = asint(dot(asfloat(r2.xyz), i.normal.xyz));
			r1.z = asint(dot(r7.xyz, r7.xyz));
			r1.w = (0 < asfloat(r1.z)) ? -1 : 0;
			r0.w = asint(-(asfloat(r0.w)) / asfloat(r1.z));
			r2.xyz = asint(r7.xyz * asfloat(r0.www) + i.normal.xyz);
			r2.xyz = (r1.www != 0) ? r2.xyz : asint(i.normal.xyz);
			r1.xy = asint(asfloat(r1.xy) + float2(-0.5, -0.492109388));
			r1.xy = asint(asfloat(r1.xy) + asfloat(r1.xy));
			r0.w = asint(dot(asfloat(r1.xy), asfloat(r1.xy)));
			r1.z = (0 < asfloat(r0.w)) ? -1 : 0;
			r0.w = asint(sqrt(asfloat(r0.w)));
			r0.w = r0.w & r1.z;
			r1.z = asint(-(asfloat(r0.w)) * 2 + 1);
			r7.z = max(asfloat(r1.z), -1);
			r1.z = (r7.z < 1) ? -1 : 0;
			r1.w = (-1 < r7.z) ? -1 : 0;
			r1.z = r1.w & r1.z;
			r1.w = (0 < asfloat(r0.w)) ? -1 : 0;
			r1.z = r1.w & r1.z;
			r1.w = asint(-(r7.z) * r7.z + 1);
			r1.w = asint(sqrt(asfloat(r1.w)));
			r0.w = asint(asfloat(r1.w) / asfloat(r0.w));
			r0.w = r0.w & r1.z;
			r7.xy = asfloat(r0.ww) * asfloat(r1.xy);
			r1.xyz = asint(r4.xyz + float3(-128, -128, -128));
			r1.xyz = asint(asfloat(r0.zzz) * asfloat(r1.xyz));
			r4.xyz = -(r8.xyz) + r7.xyz;
			r1.xyz = asint(asfloat(r1.xyz) * float3(0.00390625, 0.00390625, 0.00390625) + -(r6.xyz));
			r0.z = asint(dot(asfloat(r1.xyz), i.normal.xyz));
			r0.w = asint(dot(r4.xyz, r4.xyz));
			r1.x = (0 < asfloat(r0.w)) ? -1 : 0;
			r0.z = asint(-(asfloat(r0.z)) / asfloat(r0.w));
			r1.yzw = asint(r4.xyz * asfloat(r0.zzz) + asfloat(r2.xyz));
			r1.xyz = (r1.xxx != 0) ? r1.yzw : r2.xyz;
			r0.z = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
			r0.z = asint(sqrt(asfloat(r0.z)));
			r5.xyz = asint(asfloat(r1.xyz) / asfloat(r0.zzz));
		}
	} else {
		r3.xyz = i.position.xyz;
		r5.xyz = asint(i.normal.xyz);
	}
	r1.xyz = asint(-(r3.xyz) + i.position.xyz);
	r0.z = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r0.z = asint(sqrt(asfloat(r0.z)));
	r0.w = asint(i.blendindices.x * 255.001953);
	r0.w = (int)asfloat(r0.w);
	r0.w = r0.w * 3;
	r3.w = 1;
	r1.x = asint(dot(gBoneMtx[r0.w / 3][0], r3));
	r1.y = asint(dot(gBoneMtx[r0.w / 3][1], r3));
	r1.z = asint(dot(gBoneMtx[r0.w / 3][2], r3));
	r2.xyz = asint(asfloat(r1.yyy) * gWorld[1].xyz);
	r2.xyz = asint(asfloat(r1.xxx) * gWorld[0].xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r1.zzz) * gWorld[2].xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) + gWorld[3].xyz);
	o.texcoord3 = -(asfloat(r2.xyz)) + gViewInverse[3].xyz;
	r2.x = asint(dot(gBoneMtx[r0.w / 3][0].xyz, asfloat(r5.xyz)));
	r2.y = asint(dot(gBoneMtx[r0.w / 3][1].xyz, asfloat(r5.xyz)));
	r2.z = asint(dot(gBoneMtx[r0.w / 3][2].xyz, asfloat(r5.xyz)));
	r0.z = asint(min(asfloat(r0.z), 0.0399999991));
	r3.xyz = i.color.xyz;
	r3.w = 1;
	o.texcoord2 = asfloat(r0.z) * float4(6, 6, 6, 6) + r3;
	r3.xyz = asfloat(r2.xyz) * envEffThickness;
	r3.xyz = asfloat(r0.yyy) * r3.xyz;
	r1.xyz = asint(r3.xyz * envEffScale.yyy + asfloat(r1.xyz));
	r3 = asfloat(r1.y) * gWorldViewProj[1];
	r3 = asfloat(r1.x) * gWorldViewProj[0] + r3;
	r3 = asfloat(r1.z) * gWorldViewProj[2] + r3;
	r3 = r3 + gWorldViewProj[3];
	r4.xyz = asfloat(r2.yyy) * gWorld[1].xyz;
	r2.xyw = asint(asfloat(r2.xxx) * gWorld[0].xyz + r4.xyz);
	o.texcoord1.xyz = asfloat(r2.zzz) * gWorld[2].xyz + asfloat(r2.xyw);
	r2 = asint(asfloat(r1.y) * gWorld[1]);
	r2 = asint(asfloat(r1.x) * gWorld[0] + asfloat(r2));
	r1 = asint(asfloat(r1.z) * gWorld[2] + asfloat(r2));
	o.texcoord6 = asfloat(r1) + gWorld[3];
	r0.x = asint(asfloat(r0.x) * 2 + asfloat(r0.y));
	r0.x = asint(min(asfloat(r0.x), 1));
	o.texcoord4 = asfloat(r0.x) * envEffScale.x;
	o.sv_position = r3;
	o.texcoord1.w = r3.w;
	o.texcoord = i.texcoord.xy;

	return o;
}
