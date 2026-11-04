float gDayNightScale : register(c136);
float gDistanceScale : register(c134);
float gLifeTimeScale : register(c133);
float gTotalLifeTimeScale : register(c135);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
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
	float4 r4;
	float4 r5;
	float3 r6;
	float4 r7;
	r0.xyz = float3(1, 256, 65536);
	r0.yzw = r0.xyz * vCustomData[2].yyy;
	r0.yzw = frac(r0.yzw);
	r0.yzw = r0.yzw * 0.1;
	r1.xy = float2(1.05, 2);
	r1.x = vCustomData[1].w * -r1.x + r1.y;
	r1.x = max(r1.x, 0.1);
	r1.y = -0.009765625 + i.position.z;
	r1.y = max(r1.y, 0);
	r1.y = min(r1.y, 0.030273438);
	r1.xy = r1.xy * vCustomData[0].ww;
	r2 = vCustomData[0];
	r3 = r2.xxx * float3(1, 1, 0) + float3(0, 0, 33.032257);
	r1.z = r1.y * r3.z + 0.005;
	r4.w = r1.y * r3.z + 0.005;
	r1.y = r1.z * 2.2;
	r1.y = min(r1.y, 5);
	r1.x = r1.x * 9.12 + -r1.y;
	r1.x = max(r1.x, 0);
	r5.xyz = r0.yzw * r1.xxx;
	r6 = float3(0.004, 0.002, 0);
	r0.yzw = r6.xyz * vCustomData[1].yyy;
	r1.x = saturate(r2.w * -0.003 + r1.z);
	r1.x = r1.x * 0.25 + 0.75;
	r1.x = saturate(r2.z * -gTotalLifeTimeScale.x + r1.x);
	r7 = r0.yzww * r1.x;
	r0.x = r2.z * -gLifeTimeScale.x + r0.x;
	r0.x = r1.z * -gDistanceScale.x + r0.x;
	r5.w = saturate(r2.y * -2.5 + r0.x);
	r0 = r7 * r1.z + r5;
	r1.x = globalDayNightEffects.w * globalDayNightEffects.w;
	r2.z = 7.6;
	r1.x = r1.x * r2.z + gDayNightScale.x;
	o.color.xyz = r0.xyz * r1.xxx;
	o.color.w = r0.w;
	r0.x = -r1.z * gWorldView[1].z;
	r0.yz = i.position.xy;
	r4.xy = r3.xy * r0.yz;
	r0.x = r4.x * gWorldView[0].z + r0.x;
	r0.x = r4.y * gWorldView[2].z + r0.x;
	r0.x = r0.x + gWorldView[3].z;
	o.texcoord3 = -r0.x;
	r0.xyz = r4.xyw + -i.position.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = -r0.x + vCustomData[0].w;
	r0.y = 1 / vCustomData[2].w;
	r0.x = saturate(r0.y * r0.x);
	r0.x = r0.x + -1;
	r0.y = (r6.z < vCustomData[2].w) ? 1 : 0;
	o.texcoord7.w = r0.y * r0.x + 1;
	r0 = -r1.z * gWorld[1];
	r1 = -r1.z * gWorldViewProj[1];
	r1 = r4.x * gWorldViewProj[0] + r1;
	r1 = r4.y * gWorldViewProj[2] + r1;
	r1 = r1 + gWorldViewProj[3];
	r0 = r4.x * gWorld[0] + r0;
	r0 = r4.y * gWorld[2] + r0;
	r0 = r0 + gWorld[3];
	r3 = -r0.xyz + gViewInverse[3].xyz;
	o.texcoord4 = r0;
	r0.xyz = normalize(r3.xyz);
	r2.yzw = -r2.www * gWorld[1].xyz;
	r3 = normalize(r2.yzw);
	r2.yzw = r0.xyz * r3.yzx;
	r0.xyz = r3.xyz * r0.yzx + -r2.yzw;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r2.yzw = r3.yzx * r0.xyz;
	r0.xyz = r0.zxy * r3.zxy + -r2.yzw;
	o.texcoord6 = r3.xyz;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord7.xyz = r0.www * r0.xyz;
	o.position = r1;
	o.texcoord = i.texcoord.xy;
	o.texcoord1 = r1;
	o.texcoord2 = r1;
	o.texcoord5.xyz = gWorld[3].xyz;
	o.texcoord5.w = r2.x * 0.009765625;

	return o;
}
