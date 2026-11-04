float4 AirResist : register(c217);
float WindStr : register(c218);
float4 gWindParams : register(c216);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalScalars2 : register(c36);
float4 globalScalars3 : register(c49);
float4 globalScalars4 : register(c51);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 color1 : COLOR1;
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
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float2 r3;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	o.texcoord7 = r0.xyz + gWorld[3].xyz;
	r0.xyz = gWorld[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.xyz = gWorld[1].xyz * i.tangent.yyy;
	r0.xyz = i.tangent.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.tangent.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r2 = normalize(r0.xyz);
	r0.xyz = r1.yzx * r2.zxy;
	r0.xyz = r2.yzx * r1.zxy + -r0.xyz;
	o.texcoord1.xyz = r1.xyz;
	o.texcoord4 = r2.xyz;
	o.texcoord5.xyz = r0.xyz * i.tangent.www;
	o.texcoord2.y = globalScalars2.w * i.color.y;
	r0.xyz = float3(1E-05, 0.01, 1);
	r0.y = AirResist.w * r0.y + r0.z;
	r1.xyz = float3(6, 10, 10) * i.position.xxz;
	r0.z = globalScalars3.y * r0.y + r1.x;
	r0.y = r0.y * globalScalars3.y;
	r0.w = r1.z + r1.y;
	r0.w = i.position.y * 10 + r0.w;
	r0.w = r0.y * gWindParams.z + r0.w;
	r0.y = r0.y * gWindParams.w;
	r0.y = i.position.y * 4 + r0.y;
	r0.y = r0.y * 0.15915494 + 0.5;
	r0.y = frac(r0.y);
	r0.y = r0.y * 6.2831855 + -3.1415927;
	r1.y = sin(r0.y);
	r0.y = r0.w * 0.15915494 + 0.5;
	r0.y = frac(r0.y);
	r0.y = r0.y * 6.2831855 + -3.1415927;
	r2.y = sin(r0.y);
	r0.y = r0.z * 0.15915494 + 0.5;
	r0.y = frac(r0.y);
	r0.y = r0.y * 6.2831855 + -3.1415927;
	r3.y = sin(r0.y);
	r0.y = saturate(WindStr.x);
	r0.y = abs(r3.y) * r0.y;
	r0.y = abs(r2.y) * r0.y;
	r0.y = abs(r1.y) * r0.y;
	r1.x = r0.x + globalScalars3.z;
	r1.y = r0.x + globalScalars4.z;
	r1.z = 1E-05;
	r2 = normalize(r1.xyz);
	r0.x = dot(r2.xyz, i.normal.xyz);
	r0.x = max(r0.x, 0.25);
	r0.x = min(r0.x, 1);
	r0.z = AirResist.w * i.color1.z;
	r0.z = r0.z * 5;
	r1.z = -r0.z;
	r1.xy = -i.color1.xx;
	r1.xyz = r1.xyz * i.normal.xyz;
	r0.xzw = r0.xxx * r1.xyz;
	r0.xyz = r0.xzw * r0.yyy + i.position.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = i.texcoord.xy;
	o.texcoord2.xzw = i.color.xzw;
	o.texcoord5.w = i.tangent.w;

	return o;
}
