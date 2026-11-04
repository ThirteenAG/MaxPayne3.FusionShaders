row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
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
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	o.texcoord4.xyz = r0.xyz + gWorld[3].xyz;
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
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord3 = float4(0, 0, 0, 1) * i.color.w;
	o.texcoord.w = r0.w;
	o.texcoord5 = r0;
	o.texcoord2.xyz = i.normal.xyz;
	o.texcoord4.w = 0;

	return o;
}
