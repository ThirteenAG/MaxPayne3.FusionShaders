sampler2D BackBufferSampler : register(s1);
sampler2D NoiseMapSampler : register(s2);
sampler2D TextureSampler : register(s0);
row_major float4x4 gViewInverse : register(c12);
float4 vCustomData[4] : register(c137);

struct PS_IN
{
	float4 texcoord1 : TEXCOORD1;
	float texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xyz = -gViewInverse[3].xyz + i.texcoord5.xyz;
	r0.x = dot(r0.xyz, i.texcoord7.xyz);
	r0.yzw = gViewInverse[3].xyz + -i.texcoord4.xyz;
	r1.xyz = normalize(r0.yzw);
	r0.y = dot(r1.xyz, i.texcoord7.xyz);
	r0.y = 1 / r0.y;
	r0.x = r0.y * r0.x;
	r0.xyz = r0.xxx * r1.xyz + gViewInverse[3].xyz;
	r0.xyz = r0.xyz + -i.texcoord5.xyz;
	r0.w = dot(r0.xyz, i.texcoord6.xyz);
	r0.xyz = i.texcoord6.xyz * -r0.www + r0.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.y = 1 / i.texcoord5.w;
	r0.x = r0.y * r0.x;
	r0.x = r0.x * -0.5 + 0.5;
	r0.y = i.texcoord.y;
	r0 = tex2D(TextureSampler, r0.xy);
	r1.xy = float2(0.5, 0.15915494);
	r0.y = vCustomData[2].x * r1.y + r1.x;
	r0.y = frac(r0.y);
	r0.y = r0.y * 6.2831855 + -3.1415927;
	r1.y = sin(r0.y);
	r0.y = i.texcoord1.w + i.texcoord1.w;
	r0.y = 1 / r0.y;
	r2.xy = i.texcoord1.xy * r0.yy + 0.5;
	r2.z = -r2.y + 1;
	r0.yz = r1.yy + r2.xz;
	r1 = tex2D(BackBufferSampler, r2.xz);
	r0.w = dot(r1.zyw, float3(1, 255, 0.003921569));
	r0.w = r0.w + i.texcoord3.x;
	r0.yz = r0.yz + r0.yz;
	r1 = tex2D(NoiseMapSampler, r0.yz);
	r0.y = 1 + -i.color.w;
	r0.y = saturate(r1.x * r0.y);
	r1.xyz = r1.xyz * i.color.www;
	r0.z = saturate(i.color.w);
	r2.x = min(r0.y, r0.z);
	r0.y = r2.x * -0.5 + r0.z;
	r0.y = r0.y * i.color.w;
	r1.w = saturate(r0.y * 2.5);
	r1 = r0.x * r1;
	r0 = (r0.w >= 0) ? r1 : 0;
	r1.x = pow(i.texcoord7.w, vCustomData[3].w);
	o = r0 * r1.x;

	return o;
}
