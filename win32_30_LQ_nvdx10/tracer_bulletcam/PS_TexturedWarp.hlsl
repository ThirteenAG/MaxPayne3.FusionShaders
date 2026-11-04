sampler2D BackBufferSampler : register(s1);
sampler2D NoiseMapSampler : register(s3);
sampler2D TextureSampler : register(s0);
float4 vCustomData[4] : register(c137);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord7 : TEXCOORD7;
	float4 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xy = float2(0.5, 0.15915494);
	r0.x = vCustomData[2].x * r0.y + r0.x;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	r1.y = sin(r0.x);
	r0.x = i.texcoord1.w + i.texcoord1.w;
	r0.x = 1 / r0.x;
	r0.xy = i.texcoord1.xy * r0.xx + 0.5;
	r0.z = -r0.y + 1;
	r1 = r1.y + r0.xzxz;
	r1 = r1 * float4(7.2, 7.2, 4.8, 4.8);
	r2 = tex2D(NoiseMapSampler, r1.xy);
	r1 = tex2D(NoiseMapSampler, r1.zw);
	r0.yw = r1.yx + r2.yx;
	r0.yw = r0.yw * 0.006;
	r1.x = i.texcoord2.w + i.texcoord2.w;
	r1.x = 1 / r1.x;
	r1.xy = i.texcoord2.xy * r1.xx + 0.5;
	r1.z = -r1.y + 1;
	r1.xy = r0.zx + -r1.zx;
	r1.xy = r1.xy + 1E-05;
	r1.z = dot(r1.yx, r1.yx) + 0;
	r1.z = rsqrt(r1.z);
	r1.xy = r1.zz * r1.xy;
	r2 = tex2D(TextureSampler, i.texcoord.xy);
	r1.z = saturate(r2.x + -0.1);
	r1.xy = r1.zz * r1.xy;
	r0.yw = r1.xy * 0.15 + r0.yw;
	r2 = r0.wyyw + r0.xzxz;
	r0 = tex2D(BackBufferSampler, r0.xz);
	r3 = tex2D(BackBufferSampler, r2.zw);
	r2 = tex2D(BackBufferSampler, r2.xy);
	r0.w = r1.z * -0.2 + 0.2;
	r1.x = r1.z * i.color.w;
	r1.x = saturate(r1.x * 5);
	r1.y = -r0.w + 1;
	r1.y = r1.y * 0.5;
	r3.xyz = r1.yyy * r3.xyz;
	r0.xyz = r0.xyz * r0.www + r3.xyz;
	o.xyz = r2.xyz * r1.yyy + r0.xyz;
	r0.x = pow(i.texcoord7.w, vCustomData[3].w);
	o.w = r0.x * r1.x;

	return o;
}
