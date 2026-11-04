sampler2D DiffuseSampler : register(s0);
float4 colorize : register(c47);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float r3;
	r0.xyz = 1E-05 + i.texcoord1.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r1.x = r0.z * r0.w + -1;
	r1.xy = (r1.xx >= 0) ? 0 : float2(1, 2);
	r2.xyz = r0.www * r0.xyz;
	r0.x = max(-1, -r2.z);
	r0.y = dot(r2.yz, float2(-0.5, 0.8660254)) + r0.x;
	r1.xy = (r0.yy >= 0) ? r1.xy : float2(2, 6);
	r0.y = dot(r2.yz, float2(0.5, -0.8660254)) + 0;
	r1.z = max(r0.x, r0.y);
	r0.x = dot(r2.xyz, float3(0.4330127, -0.25, -0.8660254));
	r0.y = -r0.x + r1.z;
	r2.w = max(r1.z, r0.x);
	r0.xy = (r0.yy >= 0) ? r1.xy : float2(3, 8);
	r1.x = dot(r2.yzx, float3(-0.25, -0.8660254, -0.4330127));
	r1.y = -r1.x + r2.w;
	r3 = max(r2.w, r1.x);
	r0.xy = (r1.yy >= 0) ? r0.xy : float2(4, 10);
	r1.x = dot(r2.yz, float2(-0.9396926, -0.34202015)) + r3.x;
	r0.xy = (r1.xx >= 0) ? r0.xy : float2(5, 11);
	r1.x = dot(r2.yz, float2(0.9396926, 0.34202015)) + 0;
	r2.w = max(r3.x, r1.x);
	r1.x = dot(r2.xyz, float3(0.81379765, 0.4698463, -0.34202015));
	r1.y = -r1.x + r2.w;
	r3 = max(r2.w, r1.x);
	r0.xy = (r1.yy >= 0) ? r0.xy : float2(6, 7);
	r1.x = dot(r2.yzx, float3(-0.4698463, 0.34202015, 0.81379765));
	r1.y = -r1.x + r3.x;
	r2.w = max(r3.x, r1.x);
	r0.xy = (r1.yy >= 0) ? r0.xy : float2(7, 12);
	r1.x = dot(r2.yz, float2(0.9396926, 0.34202015)) + r2.w;
	r0.xy = (r1.xx >= 0) ? r0.xy : float2(8, 9);
	r1.x = dot(r2.yz, float2(-0.9396926, -0.34202015)) + 0;
	r3 = max(r2.w, r1.x);
	r1.x = dot(r2.xyz, float3(-0.81379765, -0.4698463, 0.34202015));
	r1.y = -r1.x + r3.x;
	r2.w = max(r3.x, r1.x);
	r0.xy = (r1.yy >= 0) ? r0.xy : float2(9, 13);
	r1.x = dot(r2.yzx, float3(0.4698463, -0.34202015, -0.81379765));
	r1.y = -r1.x + r2.w;
	r3 = max(r2.w, r1.x);
	r0.xy = (r1.yy >= 0) ? r0.xy : float2(10, 5);
	r1.x = dot(r2.xyz, float3(-0.4330127, 0.25, 0.8660254));
	r1.y = -r1.x + r3.x;
	r2.w = max(r3.x, r1.x);
	r0.xy = (r1.yy >= 0) ? r0.xy : float2(11, 14);
	r1.x = dot(r2.yzx, float3(0.25, 0.8660254, 0.4330127));
	r1.y = -r1.x + r2.w;
	r3 = max(r2.w, r1.x);
	r0.xy = (r1.yy >= 0) ? r0.xy : float2(12, 14);
	r1.x = dot(r2.yz, float2(0.5, 0.8660254)) + r3.x;
	r1.y = dot(r2.yz, float2(-0.5, -0.8660254)) + 0;
	r2.x = max(r3.x, r1.y);
	r0.z = r0.z * -r0.w + r2.x;
	r0.xy = (r1.xx >= 0) ? r0.xy : float2(13, 14);
	r0.xy = (r0.zz >= 0) ? r0.xy : float2(14, 13);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.z = r1.w + -0.5;
	r0.x = (r0.z >= 0) ? r0.x : r0.y;
	r0.y = abs(colorize.x);
	r0.y = (-r0.y >= 0) ? r0.x : 0;
	r0.z = r0.x * 16;
	r1.x = colorize.x;
	r2 = r1.x + float4(-1, -2, -3, -4);
	r1.yz = (-abs(r2.xz) >= 0) ? r0.zz : 0;
	r2.xy = (-abs(r2.yw) >= 0) ? r0.xx : 0;
	r0.y = r0.y + r1.y;
	r0.w = r1.z + r2.x;
	o.xy = r0.yw * 0.003921569;
	r1.xyz = r1.xxx + float3(-5, -6, -7);
	r0.xyz = (-abs(r1.yxz) >= 0) ? r0.xzz : 0;
	r0.x = r0.x + r0.z;
	r0.y = r2.y + r0.y;
	o.zw = r0.yx * 0.003921569;

	return o;
}
