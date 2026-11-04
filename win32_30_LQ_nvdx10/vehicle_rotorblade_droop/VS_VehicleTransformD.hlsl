float3 droopParams : register(c196);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float2 gravityDroop : register(c197);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = float3(1, 1, 0) * i.position.xyx;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.y = r0.x * droopParams.x;
	r0.x = r0.x * gravityDroop.x;
	r0.y = r0.y * gravityDroop.x;
	r1.z = r0.y * -0.01 + i.position.z;
	r1.xy = i.position.xy;
	r0.yzw = r1.xyz + 1E-05;
	r2 = normalize(r0.yzw);
	r0.y = dot(r2.xzy, float3(0.70710677, 0.70710677, 7.070997E-06));
	r0.y = r0.y + gravityDroop.y;
	r0.y = r0.y * droopParams.z;
	r0.y = r0.y * 0.15915494 + 0.5;
	r0.y = frac(r0.y);
	r0.y = r0.y * 6.2831855 + -3.1415927;
	r2.y = sin(r0.y);
	r0.z = 0.01;
	r0.y = r0.z * droopParams.y;
	r0.x = r0.y * r0.x;
	r0.x = r0.x * -r2.y + r1.z;
	r0.yzw = gWorld[1].xyz * i.position.yyy;
	r0.yzw = i.position.xxx * gWorld[0].xyz + r0.yzw;
	r0.yzw = r0.xxx * gWorld[2].xyz + r0.yzw;
	o.texcoord6.xyz = r0.yzw + gWorld[3].xyz;
	r0.yzw = gWorld[1].xyz * i.normal.yyy;
	r0.yzw = i.normal.xxx * gWorld[0].xyz + r0.yzw;
	r0.yzw = i.normal.zzz * gWorld[2].xyz + r0.yzw;
	r0.yzw = r0.yzw + 1E-05;
	r1.x = dot(r0.yzw, r0.yzw);
	r1.x = rsqrt(r1.x);
	o.texcoord1.xyz = r0.yzw * r1.xxx;
	r0.yzw = gWorld[1].xyz * i.tangent.yyy;
	r0.yzw = i.tangent.xxx * gWorld[0].xyz + r0.yzw;
	r0.yzw = i.tangent.zzz * gWorld[2].xyz + r0.yzw;
	r0.yzw = r0.yzw + 1E-05;
	r1.x = dot(r0.yzw, r0.yzw);
	r1.x = rsqrt(r1.x);
	o.texcoord4 = r0.yzw * r1.xxx;
	r1 = gWorldViewProj[1] * i.position.y;
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r0 = r0.x * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = i.texcoord.xy;
	o.texcoord2 = i.color.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);
	o.texcoord5 = i.tangent.w;
	o.texcoord6.w = 1;

	return o;
}
