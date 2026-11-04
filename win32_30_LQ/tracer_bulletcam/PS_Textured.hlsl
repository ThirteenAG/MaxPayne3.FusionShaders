sampler2D TextureSampler : register(s0);
row_major float4x4 gViewInverse : register(c12);
float4 vCustomData[4] : register(c137);

struct PS_IN
{
	float3 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
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
	r0.x = saturate(r0.x + -0.1);
	r0.yzw = 0.001 + i.color.xyz;
	r1.xyz = r0.yzw * i.color.www;
	r1.w = i.color.w;
	r0 = r0.x * r1;
	r1.x = pow(i.texcoord7.w, vCustomData[3].w);
	o = r0 * r1.x;

	return o;
}
