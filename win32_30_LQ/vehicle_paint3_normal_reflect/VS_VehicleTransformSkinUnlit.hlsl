float BoundRadius : register(c196);
sampler2D DamageSampler : register(s1);
row_major float3x4 gBoneMtx[40] : register(c76);
row_major float4x4 gWorldViewProj : register(c8);
bool switchOn : register(b8);

struct VS_IN
{
	float4 position : POSITION;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float2 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	int a0;
	if (switchOn) {
		r0.x = dot(i.position.xyz, i.position.xyz);
		r0.x = rsqrt(r0.x);
		r0.y = 1 / r0.x;
		r0.z = i.position.z * -r0.x + 1;
		r0.z = r0.z * 0.5;
		r0.xw = i.position.xy * r0.xx + 1E-05;
		r1.xy = r0.xw * r0.xw;
		r1.x = r1.y + r1.x;
		r1.x = rsqrt(r1.x);
		r0.xw = r0.xw * r1.xx;
		r0.xz = r0.zz * r0.xw;
		r1.xy = r0.xz * 0.5 + 0.5;
		r0.xz = r1.xy * 126.73267;
		r2.xy = frac(abs(r0.xz));
		r0.xz = (r0.xz >= -r0.xz) ? 1 : 0;
		r3 = lerp(-r2.xy, r2.xy, r0.xz);
		r1.zw = 0;
		r2 = tex2Dlod(DamageSampler, r1);
		r1 = r3.xyxx * -0.007890625 + r1.xyxx;
		r4 = r1.wywy + float4(0.007890625, 0, 0, 0.007890625);
		r5 = r4.xyxx * float4(1, 1, 0, 0);
		r5 = tex2Dlod(DamageSampler, r5);
		r4 = r4.zwxx * float4(1, 1, 0, 0);
		r4 = tex2Dlod(DamageSampler, r4);
		r1 = r1 * float4(1, 1, 0, 0) + float4(0.007890625, 0.007890625, 0, 0);
		r1 = tex2Dlod(DamageSampler, r1);
		r0.x = r2.x * 1.5258789E-05;
		r0.z = frac(r0.x);
		r0.w = r0.x + -r0.z;
		r0.x = (r0.x < -r0.x) ? 1 : 0;
		r0.z = (-r0.z < r0.z) ? 1 : 0;
		r6.z = r0.x * r0.z + r0.w;
		r0.x = r6.z * -65536 + r2.x;
		r0.z = r0.x * 0.00390625;
		r0.w = frac(r0.z);
		r1.y = r0.z + -r0.w;
		r0.z = (r0.z < -r0.z) ? 1 : 0;
		r0.w = (-r0.w < r0.w) ? 1 : 0;
		r6.y = r0.z * r0.w + r1.y;
		r6.x = r6.y * -256 + r0.x;
		r0.x = r5.x * 1.5258789E-05;
		r0.z = frac(r0.x);
		r0.w = r0.x + -r0.z;
		r0.x = (r0.x < -r0.x) ? 1 : 0;
		r0.z = (-r0.z < r0.z) ? 1 : 0;
		r2.z = r0.x * r0.z + r0.w;
		r0.x = r2.z * -65536 + r5.x;
		r0.z = r0.x * 0.00390625;
		r0.w = frac(r0.z);
		r1.y = r0.z + -r0.w;
		r0.z = (r0.z < -r0.z) ? 1 : 0;
		r0.w = (-r0.w < r0.w) ? 1 : 0;
		r2.y = r0.z * r0.w + r1.y;
		r2.x = r2.y * -256 + r0.x;
		r0.x = r4.x * 1.5258789E-05;
		r0.z = frac(r0.x);
		r0.w = r0.x + -r0.z;
		r0.x = (r0.x < -r0.x) ? 1 : 0;
		r0.z = (-r0.z < r0.z) ? 1 : 0;
		r5.z = r0.x * r0.z + r0.w;
		r0.x = r5.z * -65536 + r4.x;
		r0.z = r0.x * 0.00390625;
		r0.w = frac(r0.z);
		r1.y = r0.z + -r0.w;
		r0.z = (r0.z < -r0.z) ? 1 : 0;
		r0.w = (-r0.w < r0.w) ? 1 : 0;
		r5.y = r0.z * r0.w + r1.y;
		r5.x = r5.y * -256 + r0.x;
		r0.x = r1.x * 1.5258789E-05;
		r0.z = frac(r0.x);
		r0.w = r0.x + -r0.z;
		r0.x = (r0.x < -r0.x) ? 1 : 0;
		r0.z = (-r0.z < r0.z) ? 1 : 0;
		r4.z = r0.x * r0.z + r0.w;
		r0.x = r4.z * -65536 + r1.x;
		r0.z = r0.x * 0.00390625;
		r0.w = frac(r0.z);
		r1.x = r0.z + -r0.w;
		r0.z = (r0.z < -r0.z) ? 1 : 0;
		r0.w = (-r0.w < r0.w) ? 1 : 0;
		r4.y = r0.z * r0.w + r1.x;
		r4.x = r4.y * -256 + r0.x;
		r0.xz = -r3.xy + 1;
		r1.xyz = r0.xxx * r6.xyz;
		r2.xyz = r3.xxx * r2.xyz;
		r2.xyz = r0.zzz * r2.xyz;
		r1.xyz = r1.xyz * r0.zzz + r2.xyz;
		r0.xzw = r0.xxx * r5.xyz;
		r0.xzw = r0.xzw * r3.yyy + r1.xyz;
		r1.xyz = r3.xxx * r4.xyz;
		r0.xzw = r1.xyz * r3.yyy + r0.xzw;
		r0.xzw = r0.xzw + -128;
		r0.xzw = r0.xzw * 0.0078125;
		r1.x = 1 / BoundRadius.x;
		r0.y = r0.y * r1.x;
		r0.y = min(r0.y, 1);
		r0.xyz = r0.yyy * r0.xzw;
		r0.xyz = r0.xyz * 0.5 + i.position.xyz;
	} else {
		r0.xyz = i.position.xyz;
	}
	r1.xyz = -r0.xyz + i.position.xyz;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.y = 765.00586 * i.blendindices.x;
	a0 = r1.y;
	r0.w = 1;
	r1.y = dot(gBoneMtx[a0 / 3][0], r0);
	r1.z = dot(gBoneMtx[a0 / 3][1], r0);
	r0.x = dot(gBoneMtx[a0 / 3][2], r0);
	r2 = r1.z * gWorldViewProj[1];
	r2 = r1.y * gWorldViewProj[0] + r2;
	r0 = r0.x * gWorldViewProj[2] + r2;
	o.position = r0 + gWorldViewProj[3];
	r0.x = min(r1.x, 0.04);
	r1 = i.color.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord2 = r0.x * 6 + r1;
	o.texcoord = i.texcoord;

	return o;
}
