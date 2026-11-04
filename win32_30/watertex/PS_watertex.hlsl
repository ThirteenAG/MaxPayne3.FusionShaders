sampler2D NoiseTextureSampler : register(s1);
sampler2D NormalTextureSampler : register(s0);
float4 waterSimParams1 : register(c196);
float4 waterSimParams2 : register(c197);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
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
	float4 r5;
	float4 r6;
	r0.xy = i.texcoord.xy;
	r0.xy = r0.xy + i.color.xy;
	r0 = tex2D(NoiseTextureSampler, r0.xy);
	r0.x = r0.x * 2 + -1;
	r0.y = r0.z + -i.color.z;
	r0.x = r0.x * i.color.w;
	r0.x = r0.x * waterSimParams2.y;
	r0.x = (r0.y >= 0) ? 0 : r0.x;
	r1 = float4(0, -0.00390625, 0, 0.00390625) + i.texcoord.xyxy;
	r2 = tex2D(NormalTextureSampler, r1.xy);
	r1 = tex2D(NormalTextureSampler, r1.zw);
	r3 = float4(-0.00390625, -0.00390625, 0.00390625, 0.00390625) + i.texcoord.xyxy;
	r4 = tex2D(NormalTextureSampler, r3.xy);
	r0.y = r4.x * 0.70710677 + r2.x;
	r4 = tex2D(NormalTextureSampler, r3.zy);
	r0.y = r4.x * 0.70710677 + r0.y;
	r4 = float4(-0.00390625, 0, 0.00390625, 0) + i.texcoord.xyxy;
	r5 = tex2D(NormalTextureSampler, r4.xy);
	r4 = tex2D(NormalTextureSampler, r4.zw);
	r0.y = r0.y + r5.x;
	r0.y = r4.x + r0.y;
	r6 = tex2D(NormalTextureSampler, r3.xw);
	r3 = tex2D(NormalTextureSampler, r3.zw);
	r0.y = r6.x * 0.70710677 + r0.y;
	r0.y = r1.x + r0.y;
	r0.y = r3.x * 0.70710677 + r0.y;
	r3 = tex2D(NormalTextureSampler, i.texcoord.xy);
	r0.y = r0.y * 0.14644662 + -r3.x;
	r0.z = -r3.x + 0.5;
	r0.z = r0.z * waterSimParams1.y;
	r0.y = r0.y * waterSimParams1.x + r0.z;
	r0.x = r0.x + r0.y;
	r0.x = r0.x * waterSimParams1.w;
	r0.y = r0.x * waterSimParams2.w;
	o.y = r0.x * waterSimParams2.w + r3.y;
	r0.x = r0.y * waterSimParams2.w;
	r0.y = r3.y + -0.5;
	r0.y = r0.y * waterSimParams2.x;
	r0.y = r0.y * waterSimParams2.w + r3.x;
	o.x = r0.x * 0.5 + r0.y;
	r0.x = -r5.x + r3.x;
	r0.y = -r3.x + r4.x;
	r0.x = r0.y + r0.x;
	o.z = r0.x * 0.5 + 0.5;
	r0.x = -r2.x + r3.x;
	r0.y = r1.x + -r3.x;
	r0.x = r0.y + r0.x;
	o.w = r0.x * 0.5 + 0.5;

	return o;
}
