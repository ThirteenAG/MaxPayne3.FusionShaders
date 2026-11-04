cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer vehicle_switchon : register(b13)
{
	bool switchOn : packoffset(c0);
};

cbuffer CacheVehicleRadius : register(b4)
{
	float BoundRadius : packoffset(c0);
};

cbuffer Droop : register(b9)
{
	float alphaAdjust : packoffset(c0);
	float3 droopParams : packoffset(c0.y);
	float2 gravityDroop : packoffset(c1);
};

SamplerState DamageSampler : register(s1);
Texture2D DamageSampler_tex : register(t1);

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	r0.x = dot(i.position.xy, i.position.xy);
	r0.y = r0.x * droopParams.x;
	r0.y = r0.y * gravityDroop.x;
	r1.z = -(r0.y) * 0.00999999978 + i.position.z;
	r1.xy = i.position.xy;
	r0.yzw = r1.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = dot(r0.yzw, r0.yzw);
	r1.x = rsqrt(r1.x);
	r0.yzw = r0.yzw * r1.xxx;
	r0.y = dot(r0.ywz, float3(0.707106769, 0.707106769, 0.00000707099707));
	r0.z = droopParams.y * 0.00999999978;
	r0.x = r0.x * gravityDroop.x;
	r0.x = r0.z * r0.x;
	r0.y = r0.y + gravityDroop.y;
	r0.y = r0.y * droopParams.z;
	r0.y = sin(r0.y);
	r0.z = -(r0.x) * r0.y + r1.z;
	if (switchOn != 0) {
		r0.xy = i.position.xy;
		r0.w = dot(r0.xyz, r0.xyz);
		r0.w = sqrt(r0.w);
		r1.xyz = r0.xyz / r0.www;
		r1.z = -(r1.z) + 1;
		r1.z = r1.z * 0.5;
		r1.xy = r1.xy + float2(0.00000999999975, 0.00000999999975);
		r1.w = dot(r1.xy, r1.xy);
		r1.w = rsqrt(r1.w);
		r1.xy = r1.ww * r1.xy;
		r1.xy = r1.zz * r1.xy;
		r1.xy = r1.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
		r1.zw = r1.xy * float2(126.732674, 126.732674);
		r2.xy = (r1.zw >= -(r1.zw)) ? -1 : 0;
		r1.zw = frac(abs(r1.zw));
		r1.zw = (r2.xy != 0) ? r1.zw : -(r1.zw);
		r2 = asint(DamageSampler_tex.SampleLevel(DamageSampler, r1.xy, 0));
		r1.xy = -(r1.zw) * float2(0.00789062493, 0.00789062493) + r1.xy;
		r3 = r1.xyxy + float4(0.00789062493, 0, 0, 0.00789062493);
		r4 = DamageSampler_tex.SampleLevel(DamageSampler, r3.xy, 0);
		r3 = DamageSampler_tex.SampleLevel(DamageSampler, r3.zw, 0);
		r1.xy = r1.xy + float2(0.00789062493, 0.00789062493);
		r5 = DamageSampler_tex.SampleLevel(DamageSampler, r1.xy, 0);
		r1.x = asfloat(r2.x) * 0.0000152587891;
		r6.z = trunc(r1.x);
		r1.x = -(r6.z) * 65536 + asfloat(r2.x);
		r1.y = r1.x * 0.00390625;
		r6.y = trunc(r1.y);
		r6.x = -(r6.y) * 256 + r1.x;
		r1.x = r4.x * 0.0000152587891;
		r2.z = asint(trunc(r1.x));
		r1.x = -(asfloat(r2.z)) * 65536 + r4.x;
		r1.y = r1.x * 0.00390625;
		r2.y = asint(trunc(r1.y));
		r2.x = asint(-(asfloat(r2.y)) * 256 + r1.x);
		r1.x = r3.x * 0.0000152587891;
		r4.z = trunc(r1.x);
		r1.x = -(r4.z) * 65536 + r3.x;
		r1.y = r1.x * 0.00390625;
		r4.y = trunc(r1.y);
		r4.x = -(r4.y) * 256 + r1.x;
		r1.x = r5.x * 0.0000152587891;
		r3.z = trunc(r1.x);
		r1.x = -(r3.z) * 65536 + r5.x;
		r1.y = r1.x * 0.00390625;
		r3.y = trunc(r1.y);
		r3.x = -(r3.y) * 256 + r1.x;
		r1.xy = -(r1.zw) + float2(1, 1);
		r5.xyz = r1.xxx * r6.xyz;
		r2.xyz = asint(r1.zzz * asfloat(r2.xyz));
		r2.xyz = asint(r1.yyy * asfloat(r2.xyz));
		r2.xyz = asint(r5.xyz * r1.yyy + asfloat(r2.xyz));
		r4.xyz = r1.xxx * r4.xyz;
		r2.xyz = asint(r4.xyz * r1.www + asfloat(r2.xyz));
		r1.xyz = r1.zzz * r3.xyz;
		r1.xyz = r1.xyz * r1.www + asfloat(r2.xyz);
		r1.xyz = r1.xyz + float3(-128, -128, -128);
		r1.xyz = r1.xyz * float3(0.0078125, 0.0078125, 0.0078125);
		r0.w = r0.w / BoundRadius;
		r0.w = min(r0.w, 1);
		r1.xyz = r0.www * r1.xyz;
		r1.xyz = r1.xyz * float3(0.5, 0.5, 0.5) + r0.xyz;
	} else {
		r1.xy = i.position.xy;
		r1.z = r0.z;
	}
	r0.xy = i.position.xy;
	r0.xyz = -(r1.xyz) + r0.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = sqrt(r0.x);
	r2 = asint(r1.y * gWorldViewProj[1]);
	r2 = asint(r1.x * gWorldViewProj[0] + asfloat(r2));
	r1 = r1.z * gWorldViewProj[2] + asfloat(r2);
	o.sv_position = r1 + gWorldViewProj[3];
	r0.x = min(r0.x, 0.0399999991);
	o.texcoord2 = r0.x * float4(6, 6, 6, 6) + i.color;
	o.texcoord = i.texcoord.xy;

	return o;
}
