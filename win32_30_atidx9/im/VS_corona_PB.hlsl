row_major float4x4 gViewInverse : register(c12);
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
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	r0.x = 512;
	r0.x = r0.x + gViewInverse[3].z;
	r0.z = -r0.x;
	r0.xy = -gViewInverse[3].xy;
	r0.xyz = r0.xyz + i.normal.xyz;
	r1.xyz = r0.zxy * float3(0, 1, 0);
	r1.xyz = r0.yzx * float3(1, 0, 0) + -r1.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r2 = normalize(r1.xyz);
	r0.w = (-1 < r0.z) ? 1 : 0;
	r1.xyz = r0.www * r2.xyz;
	r2 = r0.zxy * r1.yzx;
	r2 = r0.yzx * r1.zxy + -r2.xyz;
	r2 = r2.xyz + 1E-05;
	r3 = normalize(r2.xyz);
	r2 = r0.www * r3.xyz;
	r3 = i.normal.xyz;
	r3 = -r3.xyz + i.position.xyz;
	r1.xyz = r1.xyz * r3.xxx + i.normal.xyz;
	r1.xyz = r2.xyz * r3.yyy + r1.xyz;
	r0.w = dot(r3.xyz, r3.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = 1 / r0.w;
	r0.w = r0.w * 0.35355338;
	r0.w = 1 / r0.w;
	r2 = r1.yyy * gWorldView[1].xyz;
	r1.xyw = r1.xxx * gWorldView[0].xyz + r2.xyz;
	r1.xyz = r1.zzz * gWorldView[2].xyz + r1.xyw;
	r1.xyz = r1.xyz + gWorldView[3].xyz;
	r1.w = r1.z + 512;
	r1.w = dot(r1.xyw, r1.xyw);
	r1.w = rsqrt(r1.w);
	r1.z = r1.z + 512;
	r1.z = r1.z * -r1.w + 1;
	r1.w = 1 / r1.w;
	r1.z = r1.z * r1.w;
	r1.w = r1.w + 1;
	r1.w = 1 / r1.w;
	o.position.z = -r1.w + 1;
	r1.z = 1 / r1.z;
	o.position.xy = r1.zz * r1.xy;
	r1.x = r0.z + 1;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.texcoord1.w = saturate(r0.x + -1);
	r0.x = saturate(r0.w * r1.x);
	r1.xyz = i.color.xyz;
	r0.yzw = r1.xyz * i.texcoord.yyy;
	o.texcoord1.xyz = r0.xxx * r0.yzw;
	o.position.w = 1;
	o.texcoord.x = i.texcoord.x;
	o.texcoord.y = i.color.w;

	return o;
}
