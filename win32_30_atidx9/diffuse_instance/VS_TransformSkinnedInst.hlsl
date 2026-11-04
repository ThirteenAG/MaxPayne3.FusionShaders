row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldInstanceInverseTranspose : register(c72);
row_major float4x4 gWorldInstanceMatrix : register(c68);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 normal : NORMAL;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = gWorldInstanceInverseTranspose[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorldInstanceInverseTranspose[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorldInstanceInverseTranspose[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord2.xyz = r0.www * r0.xyz;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1.xyz = r0.yyy * gWorldInstanceMatrix[1].xyz;
	r0.xyw = r0.xxx * gWorldInstanceMatrix[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gWorldInstanceMatrix[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + gWorldInstanceMatrix[3].xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.texcoord1 = r0.xyz;
	r0 = r1 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord2.w = r0.w;
	o.color = i.color;
	o.texcoord = i.texcoord.xy;

	return o;
}
