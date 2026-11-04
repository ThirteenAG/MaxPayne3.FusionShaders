row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldView : register(c4);

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
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord3 = -r0.xyz + gViewInverse[3].xyz;
	r0.xyz = gWorld[1].xyz * i.normal.yyy;
	r0.xyz = i.normal.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.normal.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord1.xyz = r0.www * r0.xyz;
	r0.xyz = gWorldView[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorldView[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorldView[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorldView[3].xyz;
	r0.w = r0.z + 512;
	r0.w = dot(r0.xyw, r0.xyw);
	r0.w = rsqrt(r0.w);
	r0.z = r0.z + 512;
	r0.z = r0.z * -r0.w + 1;
	r0.w = 1 / r0.w;
	r0.z = r0.z * r0.w;
	r0.z = 1 / r0.z;
	o.position.xy = r0.zz * r0.xy;
	r0.x = r0.w + 1;
	o.texcoord1.w = r0.w;
	r0.x = 1 / r0.x;
	o.position.z = -r0.x + 1;
	o.position.w = 1;
	o.color = i.color;
	o.texcoord = i.texcoord.xy;

	return o;
}
