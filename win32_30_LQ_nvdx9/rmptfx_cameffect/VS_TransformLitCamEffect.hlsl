float gSuperAlpha : register(c200);
float4 globalScreenSize : register(c41);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord3 : TEXCOORD3;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float3 r0;
	float3 r1;
	r0.x = i.normal.z * 0.15915494 + 0.5;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	sincos(r0.x, r1.y, r1.x);
	r0 = r1.yyx * i.normal.yxy;
	r1.x = i.normal.x * r1.x + -r0.x;
	r1.y = r0.z + r0.y;
	r0.x = 1 / globalScreenSize.y;
	r0.y = r0.x * globalScreenSize.x;
	r1.z = 0;
	r0.xz = 1;
	r0 = r0.xyz * r1.xyz;
	o.position.xyz = i.position.xyx * float3(1, 1, 0) + r0.xyz;
	o.texcoord.w = saturate(gSuperAlpha.x * i.color.w);
	o.position.w = 1;
	o.texcoord.xyz = i.color.xyz;
	o.texcoord1 = i.texcoord.xy;
	o.texcoord2 = i.texcoord3;

	return o;
}
