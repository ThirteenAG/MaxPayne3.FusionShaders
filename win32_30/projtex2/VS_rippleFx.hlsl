row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float3 r1;
	float4 r2;
	r0.xy = i.texcoord.xy * i.texcoord.xy;
	r0.x = r0.y + r0.x;
	r0.x = rsqrt(r0.x);
	o.texcoord1.xy = r0.xx * i.texcoord.xy;
	r0.yz = i.color.xx * float2(-2, 2) + float2(1, -1);
	r0.yz = r0.yz * i.texcoord.yx;
	o.texcoord1.zw = r0.xx * r0.yz;
	o.texcoord2.w = r0.x;
	r0.xyz = -gViewInverse[3].xyz + i.position.xyz;
	o.texcoord.xyz = -r0.xyz;
	r0.y = 0;
	r1 = i.texcoord.xyx * float3(1, 1, 0) + 1E-05;
	r0.w = dot(r1.xyz, r1.xyz);
	r2.x = rsqrt(r0.w);
	r2.yzw = r1.xyz * r2.xxx;
	r0.xz = r2.zy * float2(1, 0);
	r0.xyz = r2.xyz * float3(-0, -1, -0) + r0.xyz;
	o.texcoord6.xyz = r2.yzw;
	r0.xyz = r0.xyz + 1E-05;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord7 = r0.www * r0.xyz;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord.w = r0.w;
	o.texcoord2.xyz = i.normal.xyz;
	o.texcoord6.w = i.color.w;

	return o;
}
