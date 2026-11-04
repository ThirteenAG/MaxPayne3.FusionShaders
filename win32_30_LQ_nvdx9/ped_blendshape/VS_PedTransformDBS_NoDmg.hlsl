float4 gAmbientOcclusionEffect : register(c63);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
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
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
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
	float3 r3;
	float3 r4;
	r0 = i.tangent;
	r0 = r0 + i.tangent1;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r1.xyz = r0.xxx * gWorld[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gWorld[2].xyz + r1.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.xyz = i.position.xyz;
	r0.xyz = r0.xyz + i.position1.xyz;
	r2.xyz = r0.yyy * gWorld[1].xyz;
	r2.xyz = r0.xxx * gWorld[0].xyz + r2.xyz;
	r2.xyz = r0.zzz * gWorld[2].xyz + r2.xyz;
	r2.xyz = r2.xyz + gWorld[3].xyz;
	r3 = -r2.xyz + gViewInverse[3].xyz;
	o.texcoord7 = r2.xyz;
	o.texcoord6.x = dot(r1.xyz, r3.xyz);
	r2.xyz = i.normal.xyz;
	r2.xyz = r2.xyz + i.normal1.xyz;
	r4 = r2.yyy * gWorld[1].xyz;
	r2.xyw = r2.xxx * gWorld[0].xyz + r4.xyz;
	r2.xyz = r2.zzz * gWorld[2].xyz + r2.xyw;
	r2.xyz = r2.xyz + 1E-05;
	r4 = normalize(r2.xyz);
	r2.xyz = r1.zxy * r4.yzx;
	r2.xyz = r1.yzx * r4.zxy + -r2.xyz;
	o.texcoord4 = r1.xyz;
	r1.xyz = r0.www * r2.xyz;
	o.texcoord5.w = r0.w;
	o.texcoord6.y = dot(r1.xyz, r3.xyz);
	o.texcoord5.xyz = r1.xyz;
	o.texcoord6.z = dot(r4.xyz, r3.xyz);
	o.texcoord3 = r3.xyz;
	o.texcoord1.xyz = r4.xyz;
	o.texcoord2.y = globalScalars2.w * i.color.y;
	r1.yz = float2(-1, 1);
	r0.w = i.color.x * globalScalars.z + r1.y;
	r0.w = gAmbientOcclusionEffect.y * r0.w + r1.z;
	r1.x = 1 / gAmbientOcclusionEffect.y;
	r0.w = r0.w * r1.x;
	o.texcoord2.x = min(r0.w, 1);
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = float4(1, 1, 0, 0) * i.texcoord.xyxx;
	o.texcoord2.zw = i.color.zw;

	return o;
}
