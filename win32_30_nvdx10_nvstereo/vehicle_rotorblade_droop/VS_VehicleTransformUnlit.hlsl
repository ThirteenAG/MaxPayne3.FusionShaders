float3 droopParams : register(c196);
row_major float4x4 gWorldViewProj : register(c8);
float2 gravityDroop : register(c197);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
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
	r1 = gWorldViewProj[1] * i.position.y;
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r0 = r0.x * gWorldViewProj[2] + r1;
	o.position = r0 + gWorldViewProj[3];
	o.texcoord = i.texcoord.xy;
	o.texcoord2 = i.color;

	return o;
}
