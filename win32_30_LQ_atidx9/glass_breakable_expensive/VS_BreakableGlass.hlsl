float4 CrackOffset : register(c207);
row_major float3x4 gBoneMtx[40] : register(c76);
float4 gDepthFxParams : register(c18);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalFogParams : register(c37);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 normal : NORMAL;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord9 : TEXCOORD9;
	float4 color1 : COLOR1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int a0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.x = 0.5;
	if (r0.x < CrackOffset.w) {
		r0.x = i.color.w * 255 + 0.5;
		r0.y = frac(r0.x);
		r0.x = -r0.y + r0.x;
		r0.x = r0.x * 3;
		a0 = r0.x;
		r0.x = dot(gBoneMtx[a0 / 3][0].xyz, gBoneMtx[a0 / 3][0].xyz);
		r0.x = rsqrt(r0.x);
		r0.y = 1 / r0.x;
		if (0 < r0.y) {
			r1.xyz = r0.xxx * gBoneMtx[a0 / 3][0].xyz;
			r2.xyz = r0.xxx * gBoneMtx[a0 / 3][1].xyz;
			r3.xyz = r0.xxx * gBoneMtx[a0 / 3][2].xyz;
		} else {
			r1.xyz = gBoneMtx[a0 / 3][0].xyz;
			r2.xyz = gBoneMtx[a0 / 3][1].xyz;
			r3.xyz = gBoneMtx[a0 / 3][2].xyz;
		}
		r1.w = gBoneMtx[a0 / 3][0].w;
		r4 = i.position.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
		r0.x = dot(r1, r4);
		r2.w = gBoneMtx[a0 / 3][1].w;
		r0.z = dot(r2, r4);
		r3.w = gBoneMtx[a0 / 3][2].w;
		r0.w = dot(r3, r4);
		r1.w = dot(r1.xyz, i.normal.xyz);
		r2.w = dot(r2.xyz, i.normal.xyz);
		r3.w = dot(r3.xyz, i.normal.xyz);
		r1.x = dot(r1.xyz, i.tangent.xyz);
		r1.y = dot(r2.xyz, i.tangent.xyz);
		r1.z = dot(r3.xyz, i.tangent.xyz);
		o.color1.xyw = float3(1, 1, 0) * i.color.xyx;
		o.color1.z = r0.y;
	} else {
		o.color1 = 0;
		r0.xzw = i.position.xyz;
		r1.w = i.normal.x;
		r2.w = i.normal.y;
		r3.w = i.normal.z;
		r1.xyz = i.tangent.xyz;
	}
	r2.xyz = r0.zzz * gWorld[1].xyz;
	r2.xyz = r0.xxx * gWorld[0].xyz + r2.xyz;
	r2.xyz = r0.www * gWorld[2].xyz + r2.xyz;
	r2.xyz = r2.xyz + gWorld[3].xyz;
	o.texcoord3 = -r2.xyz + gViewInverse[3].xyz;
	r3.xyz = r2.www * gWorld[1].xyz;
	r3.xyz = r1.www * gWorld[0].xyz + r3.xyz;
	r3.xyz = r3.www * gWorld[2].xyz + r3.xyz;
	r3.xyz = r3.xyz + 1E-05;
	r4.xyz = normalize(r3.xyz);
	r3.xyz = r1.yyy * gWorld[1].xyz;
	r1.xyw = r1.xxx * gWorld[0].xyz + r3.xyz;
	r1.xyz = r1.zzz * gWorld[2].xyz + r1.xyw;
	r1.xyz = r1.xyz + 1E-05;
	r3.xyz = normalize(r1.xyz);
	r1.xyz = r4.yzx * r3.zxy;
	r1.xyz = r3.yzx * r4.zxy + -r1.xyz;
	o.texcoord5 = r1.xyz * i.tangent.www;
	r1 = r0.z * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.w * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	r1.xyz = r2.xyz + -gViewInverse[3].xyz;
	r1.w = r1.z * globalFogParams.x;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = r1.x * globalFogParams.z;
	r1.y = (0.0001 < abs(r1.w)) ? 1 : 0;
	r1.z = r1.w * -1.442695;
	r1.z = exp2(r1.z);
	r1.z = min(r1.z, 65504);
	r1.z = -r1.z + 1;
	r1.w = 1 / r1.w;
	r1.z = r1.w * r1.z;
	r1.z = r1.x * r1.z + -r1.x;
	r1.x = r1.y * r1.z + r1.x;
	r1.x = r1.x * -globalFogParams.y;
	r1.x = r1.x * 1.442695;
	r1.x = exp2(r1.x);
	r1.x = min(r1.x, 65504);
	o.texcoord9.x = -r1.x + 1;
	r1.x = saturate(-r0.w * gDepthFxParams.z + gDepthFxParams.w);
	r1.y = -r1.x + 1;
	r1.x = r1.y * gDepthFxParams.y + r1.x;
	o.texcoord9.y = r1.x + -1;
	o.position = r0;
	o.color = 1;
	o.texcoord = i.texcoord.xy;
	o.texcoord1.w = r0.w;
	o.texcoord1.xyz = r4.xyz;
	o.texcoord4 = r3.xyz;
	o.texcoord6.xyz = r2.xyz;
	o.texcoord6.w = 1;
	o.texcoord9.zw = 0;
	o.texcoord2.xy = i.texcoord.zw;
	o.texcoord2.zw = i.texcoord1.xy;

	return o;
}
