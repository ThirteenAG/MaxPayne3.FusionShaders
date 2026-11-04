row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalDayNightEffects : register(c42);
float4 vCustomData[4] : register(c137);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.xyz = vCustomData[0].xyz;
	r0.z = r0.z * -0.65 + 1;
	r0.w = -0.009765625 + i.position.z;
	r0.w = max(r0.w, 0);
	r0.w = min(r0.w, 0.030273438);
	r0.w = r0.w * vCustomData[0].w;
	r1.xyz = r0.xxx * float3(1, 1, 0) + float3(0, 0, 33.032257);
	r0.x = r0.w * r1.z + 0.005;
	r2.w = r0.w * r1.z + 0.005;
	r0.z = r0.x * -0.12 + r0.z;
	o.color.w = saturate(r0.y * -1.5 + r0.z);
	r3.xy = float2(1.05, 2);
	r0.y = vCustomData[1].w * -r3.x + r3.y;
	r0.y = max(r0.y, 0.1);
	r0.y = r0.y * vCustomData[0].w;
	r0.z = r0.x * 1.8;
	r0.z = min(r0.z, 5);
	r0.y = r0.y * 18.24 + -r0.z;
	r0.y = max(r0.y, 0);
	r3 = float3(1, 256, 65536);
	r3 = r3.xyz * vCustomData[2].yyy;
	r3 = frac(r3.xyz);
	r3 = r3.xyz * 0.01;
	r0.yzw = r0.yyy * r3.xyz;
	r1.z = globalDayNightEffects.w * globalDayNightEffects.w;
	r1.z = r1.z * 7.6 + 5;
	o.color.xyz = r0.yzw * r1.zzz;
	r0.yz = i.position.xy;
	r2.xy = r1.xy * r0.yz;
	r0.yzw = r2.xyw + -i.position.xyz;
	r0.y = dot(r0.yzw, r0.yzw);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.y = -r0.y + vCustomData[0].w;
	r0.z = 1 / vCustomData[2].w;
	r0.y = saturate(r0.z * r0.y);
	r0.y = r0.y + -1;
	r1.x = 0;
	r0.z = (r1.x < vCustomData[2].w) ? 1 : 0;
	o.texcoord7.w = r0.z * r0.y + 1;
	r0.y = -r0.x * gWorldView[1].z;
	r1 = -r0.x * gWorldViewProj[1];
	r1 = r2.x * gWorldViewProj[0] + r1;
	r1 = r2.y * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	r0.x = r2.x * gWorldView[0].z + r0.y;
	r0.x = r2.y * gWorldView[2].z + r0.x;
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord3 = -r0.x;
	r0 = gWorldViewProj[1] * -i.position.z;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.y * gWorldViewProj[2] + r0;
	o.texcoord2 = r0 + gWorldViewProj[3];
	o.position = r1;
	o.texcoord1 = r1;
	o.texcoord = i.texcoord.xy;
	o.texcoord4 = 0;
	o.texcoord5 = 0;
	o.texcoord6 = 0;
	o.texcoord7.xyz = 0;

	return o;
}
