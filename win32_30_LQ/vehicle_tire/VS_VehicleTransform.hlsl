row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
row_major float4x4 matWheelTransform : register(c64);

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
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
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
	float3 r3;
	r0.xyz = matWheelTransform[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * matWheelTransform[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * matWheelTransform[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + matWheelTransform[3].xyz;
	r1.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord3 = -r1.xyz + gViewInverse[3].xyz;
	r1.xyz = matWheelTransform[1].xyz * i.normal.yyy;
	r1.xyz = i.normal.xxx * matWheelTransform[0].xyz + r1.xyz;
	r1.xyz = i.normal.zzz * matWheelTransform[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r2 = normalize(r1.xyz);
	r1.xyz = matWheelTransform[1].xyz * i.tangent.yyy;
	r1.xyz = i.tangent.xxx * matWheelTransform[0].xyz + r1.xyz;
	r1.xyz = i.tangent.zzz * matWheelTransform[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r3 = normalize(r1.xyz);
	r1.xyz = r2.yzx * r3.zxy;
	r1.xyz = r3.yzx * r2.zxy + -r1.xyz;
	o.texcoord1.xyz = r2.xyz;
	o.texcoord4 = r3.xyz;
	o.texcoord5.xyz = r1.xyz * i.tangent.www;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.texcoord2 = r0.xyz;
	r0 = r1 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = i.texcoord.xy;
	o.texcoord5.w = i.tangent.w;
	o.texcoord6 = i.color.xyzx * float4(1, 1, 1, 0) + float4(0, 0, 0, 1);

	return o;
}
