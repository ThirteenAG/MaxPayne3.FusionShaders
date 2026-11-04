float4 AirResist : register(c221);
float WindStr : register(c222);
float4 gWindParams : register(c220);
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
	float4 position1 : POSITION1;
	float4 normal1 : NORMAL1;
	float4 tangent1 : TANGENT1;
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
	float4 r2;
	float3 r3;
	float3 r4;
	r0.xyz = i.position.xyz;
	r0.xyz = r0.xyz + i.position1.xyz;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r1.xyz = r0.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = r0.zzz * gWorld[2].xyz + r1.xyz;
	o.texcoord7 = r1.xyz + gWorld[3].xyz;
	r1.xyz = i.normal.xyz;
	r1.xyz = r1.xyz + i.normal1.xyz;
	r2.xyz = r1.yyy * gWorld[1].xyz;
	r2.xyz = r1.xxx * gWorld[0].xyz + r2.xyz;
	r2.xyz = r1.zzz * gWorld[2].xyz + r2.xyz;
	r2.xyz = r2.xyz + 1E-05;
	r3 = normalize(r2.xyz);
	r2 = i.tangent;
	r2 = r2 + i.tangent1;
	r4 = r2.yyy * gWorld[1].xyz;
	r4 = r2.xxx * gWorld[0].xyz + r4.xyz;
	r2.xyz = r2.zzz * gWorld[2].xyz + r4.xyz;
	r2.xyz = r2.xyz + 1E-05;
	r4 = normalize(r2.xyz);
	r2.xyz = r3.yzx * r4.zxy;
	r2.xyz = r4.yzx * r3.zxy + -r2.xyz;
	o.texcoord1.xyz = r3.xyz;
	o.texcoord4 = r4.xyz;
	o.texcoord5.xyz = r2.www * r2.xyz;
	o.texcoord5.w = r2.w;
	o.texcoord2.y = globalScalars2.w * i.color.y;
	r2.xyz = float3(1E-05, 0.01, 1);
	r3.x = r2.x + globalScalars3.z;
	r3.y = r2.x + globalScalars4.z;
	r3.z = 1E-05;
	r4 = normalize(r3.xyz);
	r0.w = dot(r4.xyz, r1.xyz);
	r0.w = max(r0.w, 0.25);
	r0.w = min(r0.w, 1);
	r1.w = AirResist.w * i.color1.z;
	r1.w = r1.w * 5;
	r3.z = -r1.w;
	r3.xy = -i.color1.xx;
	r1.xyz = r1.xyz * r3.xyz;
	r1.xyz = r0.www * r1.xyz;
	r3 = r0.xxz * float3(6, 10, 10);
	r0.w = r3.z + r3.y;
	r0.w = r0.y * 10 + r0.w;
	r1.w = AirResist.w * r2.y + r2.z;
	r2.x = r1.w * globalScalars3.y;
	r1.w = globalScalars3.y * r1.w + r3.x;
	r1.w = r1.w * 0.15915494 + 0.5;
	r1.w = frac(r1.w);
	r1.w = r1.w * 6.2831855 + -3.1415927;
	r3.y = sin(r1.w);
	r0.w = r2.x * gWindParams.z + r0.w;
	r1.w = r2.x * gWindParams.w;
	r1.w = r0.y * 4 + r1.w;
	r1.w = r1.w * 0.15915494 + 0.5;
	r1.w = frac(r1.w);
	r1.w = r1.w * 6.2831855 + -3.1415927;
	r2.y = sin(r1.w);
	r0.w = r0.w * 0.15915494 + 0.5;
	r0.w = frac(r0.w);
	r0.w = r0.w * 6.2831855 + -3.1415927;
	r4.y = sin(r0.w);
	r0.w = saturate(WindStr.x);
	r0.w = abs(r3.y) * r0.w;
	r0.w = abs(r4.y) * r0.w;
	r0.w = abs(r2.y) * r0.w;
	r0.xyz = r1.xyz * r0.www + r0.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = i.texcoord.xy;
	o.texcoord2.xzw = i.color.xzw;

	return o;
}
