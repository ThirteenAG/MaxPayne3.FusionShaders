sampler2D DiffuseSampler : register(s0);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDistFadeParams : register(c97);
float4 gStencil : register(c61);
row_major float4x4 gViewInverse : register(c12);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord6 : TEXCOORD6;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	r0.x = saturate(-1 + i.color.x);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r1.xyz;
	r0.x = r1.w * i.color.w;
	r0.yzw = 1E-05 + i.texcoord1.xyz;
	r1.xyz = normalize(r0.yzw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	r0.yw = float2(-1, -0.5);
	r0.z = r0.x * globalScalars.x + r0.w;
	r0.x = r0.x * globalScalars.x;
	r1 = (r0.z >= 0) ? 0 : -1;
	clip(r1);
	r1.xyz = -gViewInverse[3].xyz + i.texcoord6.xyz;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = 1 / r0.w;
	r1.xy = r0.ww + float2(-0.65, -0.9);
	r1.x = saturate(r1.x);
	r0.w = r1.x + -1;
	r0.w = (r1.y >= 0) ? r0.w : -0.75;
	r0.y = gDistFadeParams.x * r0.w + -r0.y;
	o.color.w = (r0.z >= 0) ? r0.y : 0;
	o.color1.w = r0.x;
	o.color2.xyw = r0.xxx * float3(0, 0, 1) + float3(0, 0.25, 0);
	r0.xy = float2(0, -1);
	o.color3 = abs(r0.xxxy) * gStencil.x;

	return o;
}
