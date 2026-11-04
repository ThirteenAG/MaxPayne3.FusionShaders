sampler2D BackBufferSampler : register(s1);
sampler2D NoiseMapSampler : register(s2);
float gHeatHazeScale : register(c130);
float gHeatHazeSize : register(c132);
float gHeatHazeWidth : register(c131);
float4 vCustomData[4] : register(c137);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0.xw = float2(0.5, 0.15915494);
	r0.x = vCustomData[2].x * r0.w + r0.x;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	r1.y = sin(r0.x);
	r0.x = r1.y + 0.3;
	r0.y = i.texcoord2.w + i.texcoord2.w;
	r0.y = 1 / r0.y;
	r1.xy = i.texcoord2.xy * r0.yy + 0.5;
	r1.z = -r1.y + 1;
	r0.y = i.texcoord1.w + i.texcoord1.w;
	r0.y = 1 / r0.y;
	r2.xy = i.texcoord1.xy * r0.yy + 0.5;
	r2.z = -r2.y + 1;
	r0.zw = -r1.xz + r2.xz;
	r0.zw = r0.zw + 1E-05;
	r1.x = dot(r0.zw, r0.zw) + 0;
	r1.x = rsqrt(r1.x);
	r1.yz = -0.5 + i.texcoord.xy;
	r0.zw = r0.zw * r1.xx + r1.yz;
	r1.x = dot(r1.yz, r1.yz) + 0;
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r3 = r0.x * float4(6.5, 9, -26.8, 42.7) + r2.xzxz;
	r3 = r3 * float4(0.1, 0.1, 0.5, 0.5);
	r4 = tex2D(NoiseMapSampler, r3.xy);
	r3 = tex2D(NoiseMapSampler, r3.zw);
	r1.yz = r3.yx + r4.yx;
	r1.w = r4.z + -0.5;
	r3.xy = r1.ww * 0.05 + r0.zw;
	r0.zw = r1.yz * gHeatHazeWidth.xx;
	r1.y = 1 + -i.color.w;
	r3.z = dot(r0.xx, r1.yy) + r3.y;
	r3 = r3.xzzx * r0.wzzw + r2.xzxz;
	r2 = tex2D(BackBufferSampler, r2.xz);
	r4 = tex2D(BackBufferSampler, r3.zw);
	r3 = tex2D(BackBufferSampler, r3.xy);
	r0.x = r0.y * i.texcoord1.x;
	r0.z = i.texcoord1.y * -r0.y + -0.5;
	r0.xy = r0.xz + float2(0, 0.5);
	r0.x = dot(r0.xy, r0.xy) + 0;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.y = r1.x * gHeatHazeSize.x;
	r0.z = r1.x * -gHeatHazeSize.x + r0.x;
	r0.z = r0.z + 0.8;
	o.w = saturate(r0.z * i.color.w);
	r0.y = saturate(r0.y * r0.y);
	r0.y = r0.y + 0.01;
	r0.x = saturate(r0.x * -100 + r0.y);
	r0.y = -r0.x + 1;
	r0.y = r0.y * 0.5;
	r1.xyz = 0.05 + i.color.xyz;
	r0.xzw = r2.xyz * r0.xxx + r1.xyz;
	r0.xzw = r4.xyz * r0.yyy + r0.xzw;
	r0.xyz = r3.xyz * r0.yyy + r0.xzw;
	o.xyz = r0.xyz * gHeatHazeScale.xxx;

	return o;
}
