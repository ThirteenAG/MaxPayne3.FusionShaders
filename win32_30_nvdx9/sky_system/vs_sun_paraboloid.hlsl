row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldView : register(c4);
float3 sunPosition : register(c146);

struct VS_OUT
{
	float4 position : POSITION;
	float3 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = sunPosition.xyz;
	r0.xyz = -r0.xyz + gViewInverse[3].xyz;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.xyz = r1.yzx * float3(1, 0, 0);
	r0.xyz = r1.zxy * float3(0, 1, 0) + -r0.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r2 = normalize(r0.xyz);
	r0.xyz = r1.zxy * r2.yzx;
	r0.xyz = r1.yzx * r2.zxy + -r0.xyz;
	r1.xyz = r1.xyz * position.yyy;
	r1.xyz = position.xxx * r2.xyz + r1.xyz;
	r0.xyz = position.zzz * r0.xyz + r1.xyz;
	r0.xyz = r0.xyz + sunPosition.xyz;
	r1 = r0.y * gWorldView[1];
	r1 = r0.x * gWorldView[0] + r1;
	r1 = r0.z * gWorldView[2] + r1;
	r1 = r1 + gWorldView[3];
	r0.w = 1 / r1.w;
	r1.xyz = r0.www * r1.xyz;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1.z = r1.z * r0.w + 1;
	r1.xy = r0.ww * r1.xy;
	r0.w = 1 / r0.w;
	r0.w = r0.w + -1;
	o.position.z = r0.w * 4.00016E-05;
	r0.w = 1 / r1.z;
	o.position.xy = r0.ww * r1.xy;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r0.xyw = r0.xxx * gWorld[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * gWorld[2].xyz + r0.xyw;
	o.texcoord = position.www * gWorld[3].xyz + r0.xyz;
	o.position.w = 1;

	return o;
}
