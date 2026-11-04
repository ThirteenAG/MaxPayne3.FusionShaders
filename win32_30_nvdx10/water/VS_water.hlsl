row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 waterRenderSimParam : register(c89);

struct VS_IN
{
	float4 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.zw = float2(0.1, 1E-05);
	r0.x = r0.z * waterRenderSimParam.x;
	r1.xyz = float3(-0, -0, -1) + i.normal.xyz;
	o.texcoord1.xyz = r0.xxx * r1.xyz + float3(0, 0, 1);
	r0.xy = r0.ww + gViewInverse[2].xy;
	r0.z = 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.xy = gViewInverse[3].xy;
	r0.z = waterRenderSimParam.z;
	r0.xyz = r0.xyz + -gWorld[3].xyz;
	r0.w = gViewInverse[2].z + gViewInverse[2].z;
	r0.w = max(abs(r0.w), 2000);
	r0.xyz = r1.xyz * r0.www + r0.xyz;
	r0.yw = r0.yy * gWorldViewProj[1].yw;
	r0.xy = r0.xx * gWorldViewProj[0].yw + r0.yw;
	r0.xy = r0.zz * gWorldViewProj[2].yw + r0.xy;
	r0.xy = r0.xy + gWorldViewProj[3].yw;
	r0.y = 1 / r0.y;
	r0.z = r0.y * r0.x;
	r0.x = r0.x * r0.y + -1;
	r0.y = abs(gViewInverse[2].z);
	r0.y = (0.9 < r0.y) ? 1 : 0;
	r0.x = r0.y * r0.x + -r0.z;
	r0.y = -r0.x + -1;
	r0.z = abs(gViewInverse[0].z);
	r0.z = (0.005 < r0.z) ? 1 : 0;
	o.texcoord3.w = r0.z * r0.y + r0.x;
	r0.xyz = gWorld[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.w = lerp(waterRenderSimParam.z, i.position.z, waterRenderSimParam.x);
	r0.xyz = r0.www * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	r1.x = r0.z + -waterRenderSimParam.z;
	r1.x = r1.x + -2;
	o.texcoord.w = saturate(r1.x * 0.5);
	r1.xyz = r0.xyz + -gViewInverse[3].xyz;
	o.texcoord2.xyz = r0.xyz;
	o.texcoord5.xyz = -r1.xyz;
	r0.xy = i.normal.xy * i.normal.xy;
	r0.x = r0.y + r0.x;
	r0.x = r0.x + 0.0001;
	r0.x = rsqrt(r0.x);
	r0.yz = -0.5 + i.color.xz;
	r0.y = r0.y * 8;
	r0.z = saturate(r0.z * 16 + -r0.w);
	r0.z = r0.z * 0.5;
	r1.x = r0.y * r0.y;
	r1.y = r0.w * r0.w + r1.x;
	r1.y = r1.y + 0.0001;
	r1.z = rsqrt(r1.y);
	r1.y = r1.z * r1.y;
	r1.x = r1.y * r1.y + -r1.x;
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = r0.x * r1.x;
	r0.x = 1 / r0.x;
	r0.x = r0.x + -0.2;
	r0.x = saturate(r0.x * 5);
	r1.z = 1 / r1.y;
	r1.y = r1.y * 0.9;
	r0.y = (r1.y < r0.y) ? 1 : 0;
	r0.x = r0.y * r0.x;
	r0.y = r0.w * r1.z;
	r1.y = r0.w * -r1.z + 1;
	r1.y = r1.y * 6;
	r1.x = r0.y * r1.x;
	r0.y = saturate(r0.y * 0.5 + 0.5);
	r0.x = r0.y * r0.x;
	r0.y = r1.x * 12 + r1.y;
	r0.x = r0.x * r0.y + -r1.y;
	r0.xy = r0.xx * i.normal.xy;
	r1.xy = r0.xy * r0.xy;
	r1.x = r1.y + r1.x;
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = r1.x + 0.0001;
	r1.x = 1 / r1.x;
	r0.z = r0.z * r1.x;
	r0.z = min(r0.z, 1);
	r0.xy = r0.xy * r0.zz + i.position.xy;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.w * gWorldViewProj[2] + r1;
	o.texcoord4.y = r0.w;
	r0 = r1.xywz + gWorldViewProj[3].xywz;
	o.position = r0.xywz;
	o.texcoord.xyz = r0.xyz;
	o.texcoord5.w = r0.z;
	o.texcoord1.w = 0;
	o.texcoord2.w = 0;
	o.texcoord3.xyz = gViewInverse[3].xyz;
	o.texcoord4.xz = i.color.xz * float2(8, 16) + float2(-4, -8);
	o.texcoord4.w = i.normal.z;

	return o;
}
